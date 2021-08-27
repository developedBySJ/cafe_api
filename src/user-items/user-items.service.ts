import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { plainToClass } from 'class-transformer'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'
import { MenuItemNotAvailableException } from 'src/exceptions/menu-item-not-available.exception'
import { UserItemNotFoundException } from 'src/exceptions/user-item-not-found'
import { MenuItemEntity } from 'src/menu-items/entities/menu-item.entity'
import { MenuItemsService } from 'src/menu-items/menu-items.service'
import { UserEntity } from 'src/users/entities/user.entity'
import { UtilsService } from 'src/utils/services'
import { IsNull, Not, Repository } from 'typeorm'
import { CreateUserItemDto } from './dto/create-user-item.dto'
import { CartMetaData } from './dto/meta.dto'
import { UpdateUserItemDto } from './dto/update-user-item.dto'
import { UserItemEntity, USER_ITEMS } from './entities/user-item.entity'

export type UserItemType = 'cart' | 'favorite'

@Injectable()
export class UserItemsService {
  constructor(
    @InjectRepository(UserItemEntity)
    private readonly _userItemRepository: Repository<UserItemEntity>,
    private readonly _menuItemService: MenuItemsService,
  ) {}

  private async _findOne(
    id: string,
    userItemType: UserItemType,
    user: UserEntity,
  ) {
    const operator = userItemType === 'cart' ? Not(IsNull()) : IsNull()
    const userItem = await this._userItemRepository.findOne({
      id,
      createdBy: user,
      qty: operator,
    })

    if (!userItem) throw new UserItemNotFoundException(userItemType, id)

    return userItem
  }

  async create({ menuItem, qty }: CreateUserItemDto, user: UserEntity) {
    const _menuItem = await this._menuItemService.findOne(menuItem)

    const operator = qty ? Not(IsNull()) : IsNull()

    const existingUserItem = await this._userItemRepository.findOne({
      createdBy: user,
      menuItem: _menuItem,
      qty: operator,
    })

    if (!existingUserItem) {
      if (qty && !_menuItem.isAvailable) {
        throw new MenuItemNotAvailableException()
      }
      const _newUserItem = this._userItemRepository.create({
        menuItem: _menuItem,
        qty,
        createdBy: user,
      })
      const newUserItem = await this._userItemRepository.save(_newUserItem)

      return newUserItem
    }

    if (existingUserItem.qty && qty) {
      existingUserItem.qty = Math.min(10, existingUserItem.qty + qty)
    }

    const userItem = await this._userItemRepository.save(existingUserItem)

    return userItem
  }

  async findAll(
    userItem: UserItemType,
    pageOption: PageOptionsDto,
    user: UserEntity,
  ) {
    const operator = userItem === 'cart' ? Not(IsNull()) : IsNull()
    const { limit, skip, page, sort } = pageOption

    const userItems = await this._userItemRepository.findAndCount({
      where: { createdBy: user, qty: operator },
      skip,
      order: { createdAt: sort },
      take: limit,
    })

    const meta: CartMetaData | undefined =
      userItem === 'cart'
        ? await this._userItemRepository
            .createQueryBuilder('getCartMetaData')
            .innerJoin('menu_items', 'menu_items', 'menu_items.id = menu_item')
            .where({ createdBy: user, qty: operator })
            .select(`SUM(menu_items.price*qty)`, 'total')
            .addSelect(
              `SUM(menu_items.price*qty*menu_items.discount)`,
              'discount',
            )
            .addSelect(`SUM(menu_items.price*qty*0.18)`, 'taxes')
            .getRawOne()
        : undefined

    const paginationResponse = UtilsService.paginationResponse({
      baseUrl: '',
      curPage: page,
      data: userItems,
      limit,
      meta,
      query: {
        sort,
      },
    })

    return paginationResponse
  }

  async update(id: string, { qty }: UpdateUserItemDto, user: UserEntity) {
    const cartItem = await this._userItemRepository.findOne({
      id,
      createdBy: user,
      qty: Not(IsNull()),
    })

    if (!cartItem) throw new UserItemNotFoundException('cart', id)

    if (qty) cartItem.qty = Math.min(10, qty)

    const updatedCartItem = await this._userItemRepository.save(cartItem)

    return updatedCartItem
  }

  async remove(id: string, userItemType: UserItemType, user: UserEntity) {
    const userItem = await this._findOne(id, userItemType, user)

    await this._userItemRepository.remove(userItem)

    return null
  }

  async removeAll(userItem: UserItemType, user: UserEntity) {
    const operator = userItem === 'cart' ? Not(IsNull()) : IsNull()

    await this._userItemRepository.delete({ qty: operator, createdBy: user })

    return null
  }
}
