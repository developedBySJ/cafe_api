import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'
import { UserItemNotFoundException } from 'src/exceptions/user-item-not-found'
import { MenuItemsService } from 'src/menu-items/menu-items.service'
import { UserEntity } from 'src/users/entities/user.entity'
import { IsNull, Not, Repository } from 'typeorm'
import { CreateUserItemDto } from './dto/create-user-item.dto'
import { UpdateUserItemDto } from './dto/update-user-item.dto'
import { UserItemEntity } from './entities/user-item.entity'

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
      user,
      qty: operator,
    })

    if (!userItem) throw new UserItemNotFoundException(userItemType, id)

    return userItem
  }

  async create({ menuItem, qty }: CreateUserItemDto, user: UserEntity) {
    const _menuItem = await this._menuItemService.findOne(menuItem)

    const operator = qty ? Not(IsNull()) : IsNull()

    const existingUserItem = await this._userItemRepository.findOne({
      user: user,
      menuItem: _menuItem,
      qty: operator,
    })

    if (!existingUserItem) {
      const _newUserItem = this._userItemRepository.create({
        menuItem: _menuItem,
        qty,
        user,
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
      where: { user: user, qty: operator },
      skip,
      order: { createdAt: sort },
      take: limit,
    })

    return userItems
  }

  async update(id: string, { qty }: UpdateUserItemDto, user: UserEntity) {
    const cartItem = await this._userItemRepository.findOne({
      id,
      user,
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

    await this._userItemRepository.delete({ qty: operator, user })

    return null
  }
}
