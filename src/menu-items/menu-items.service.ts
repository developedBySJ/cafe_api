import { Injectable, InternalServerErrorException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { plainToClass } from 'class-transformer'
import { PaginationResponseDto } from 'src/common/dto/pagination-response.dto'
import { MenuItemExistException } from 'src/exceptions/menu-item-exist.exception'
import { MenuItemNotFoundException } from 'src/exceptions/menu-item-not-found.exception'
import { MenusService } from 'src/menus/menus.service'
import { ReviewEntity } from 'src/reviews/entities/review.entity'
import { UserEntity } from 'src/users/entities/user.entity'
import { UtilsService } from 'src/utils/services'
import {
  Between,
  ILike,
  LessThanOrEqual,
  MoreThanOrEqual,
  Repository,
} from 'typeorm'
import { CreateMenuItemDto } from './dto/create-menu-item.dto'
import { MenuItemReview } from './dto/menu-item-response.dto'
import { MenuItemsFilterDto } from './dto/menu-items-filter.dto'
import { UpdateMenuItemDto } from './dto/update-menu-item.dto'
import { MenuItemEntity } from './entities/menu-item.entity'

@Injectable()
export class MenuItemsService {
  constructor(
    @InjectRepository(MenuItemEntity)
    private readonly _menuItemRepository: Repository<MenuItemEntity>,
    @InjectRepository(ReviewEntity)
    private readonly _reviewRepository: Repository<ReviewEntity>,
    private readonly _menuService: MenusService,
  ) {}

  async create(createMenuItemDto: CreateMenuItemDto, user: UserEntity) {
    const menu = await this._menuService.findOne(createMenuItemDto.menu)

    const _newMenuItem = this._menuItemRepository.create({
      ...createMenuItemDto,
      menu,
      createdBy: user,
    })
    try {
      const newMenuItem = await this._menuItemRepository.save(_newMenuItem)
      return newMenuItem
    } catch (error) {
      if (error?.code === '23505') {
        throw new MenuItemExistException()
      }
      throw new InternalServerErrorException()
    }
  }

  async findAll({
    isVeg,
    limit,
    isAvailable,
    menu,
    sortBy,
    skip,
    discount,
    prepTime,
    priceGte,
    priceLte,
    search,
    sort,
    page,
  }: MenuItemsFilterDto) {
    let priceFilter = {}

    if (priceLte && priceGte) {
      priceFilter = { price: Between(priceGte, priceLte) }
    } else if (priceGte) {
      priceFilter = { price: MoreThanOrEqual(priceGte) }
    } else if (priceLte) {
      priceFilter = { price: LessThanOrEqual(priceLte) }
    }

    const menuItems = await this._menuItemRepository.findAndCount({
      take: limit,
      skip,
      order: { ...(sortBy && { [sortBy]: sort }) },
      where: {
        ...(search && { title: ILike(`%${search}%`) }),
        ...priceFilter,
        ...(prepTime && { prepTime: LessThanOrEqual(prepTime) }),
        ...(discount && { discount: MoreThanOrEqual(discount) }),
        ...(isAvailable !== undefined && { isAvailable }),
        ...(isVeg !== undefined && { isVeg }),
        ...(menu && { menu }),
      },
    })
    const paginationResponse = UtilsService.paginationResponse({
      baseUrl: '',
      curPage: page,
      data: menuItems,
      limit,
      query: {
        isVeg,
        isAvailable,
        menu,
        sortBy,
        discount,
        prepTime,
        priceGte,
        priceLte,
        search,
        sort,
      },
    })

    return plainToClass(PaginationResponseDto, paginationResponse)
  }

  async findOne(id: string) {
    const menuItem = await this._menuItemRepository.findOne({ id })

    if (!menuItem) throw new MenuItemNotFoundException(id)

    const reviews = await this._reviewRepository.findAndCount({
      where: { menuItem },
      order: { createdAt: 'DESC' },
      take: 3,
      cache: true,
    })

    const ratings = await this._reviewRepository.query(
      `SELECT AVG(ratings) as rating FROM reviews WHERE menu_item = $1`,
      [id],
    )
    // console.log({ reviews, ratings })

    // const reviewsMeta = await this._reviewRepository.count({ where: { menuItem } })
    const reviewFields = plainToClass(MenuItemReview, {
      reviews: reviews[0],
      reviewCount: reviews[1] || 0,
      ratings: ratings[0].rating || 0,
    })

    return Object.assign(menuItem, reviewFields)
  }

  async update(id: string, updateMenuItemDto: UpdateMenuItemDto) {
    updateMenuItemDto.menu &&
      (await this._menuService.findOne(updateMenuItemDto.menu))

    const menuItem = await this.findOne(id)

    await this._menuItemRepository.save(
      Object.assign(menuItem, updateMenuItemDto),
    )

    return this.findOne(id)
  }

  async remove(id: string) {
    const menuItem = await this.findOne(id)

    await this._menuItemRepository.remove(menuItem)

    return null
  }
}
