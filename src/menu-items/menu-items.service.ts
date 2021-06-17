import { Injectable, InternalServerErrorException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { MenuItemExistException } from 'src/exceptions/menu-item-exist.exception'
import { MenuItemNotFoundException } from 'src/exceptions/menu-item-not-found.exception'
import { MenusService } from 'src/menus/menus.service'
import { Repository } from 'typeorm'
import { CreateMenuItemDto } from './dto/create-menu-item.dto'
import { UpdateMenuItemDto } from './dto/update-menu-item.dto'
import { MenuItemEntity } from './entities/menu-item.entity'

@Injectable()
export class MenuItemsService {
  constructor(
    @InjectRepository(MenuItemEntity)
    private readonly _menuItemRepository: Repository<MenuItemEntity>,
    private readonly _menuService: MenusService,
  ) {}

  async create(createMenuItemDto: CreateMenuItemDto) {
    const menu = await this._menuService.findOne(createMenuItemDto.menu)
    console.log('############## ', menu)
    const _newMenuItem = this._menuItemRepository.create({
      ...createMenuItemDto,
      menu,
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

  async findAll() {
    const menuItems = await this._menuItemRepository.find()
    return menuItems
  }

  async findOne(id: string) {
    const menuItem = await this._menuItemRepository.findOne({ id })

    if (!menuItem) throw new MenuItemNotFoundException(id)

    return menuItem
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
