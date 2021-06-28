import { Injectable, InternalServerErrorException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { plainToClass } from 'class-transformer'
import { MenuExistException } from 'src/exceptions/menu-exist.exception'
import { MenuNotFoundException } from 'src/exceptions/menu-not-found.exception'
import { Repository } from 'typeorm'
import { CreateMenuDto } from './dto/create-menu.dto'
import { MenuFilterDto } from './dto/menu-filter.dto'
import { UpdateMenuDto } from './dto/update-menu.dto'
import { MenuEntity } from './entities/menu.entity'

@Injectable()
export class MenusService {
  constructor(
    @InjectRepository(MenuEntity)
    private readonly _menusRepository: Repository<MenuEntity>,
  ) {}
  async create(createMenuDto: CreateMenuDto) {
    const newMenu = this._menusRepository.create(createMenuDto)

    try {
      await this._menusRepository.save(newMenu)
      return this.findOne(newMenu.id)
    } catch (error) {
      if (error?.code === '23505') throw new MenuExistException()

      throw new InternalServerErrorException()
    }
  }

  async findAll({ skip, sort, search, page, limit, isActive }: MenuFilterDto) {
    const menus = await this._menusRepository
      .createQueryBuilder()
      .orderBy({ createdAt: sort })
      .where({ ...(isActive !== undefined && { isActive }) })
      .skip(skip)
      .limit(limit)
      .getManyAndCount()

    return menus
  }

  async findOne(id: string) {
    const menu = await this._menusRepository.findOne(id)

    if (!menu) throw new MenuNotFoundException(id)

    return menu
  }

  async update(id: string, updateMenuDto: UpdateMenuDto) {
    const menu = await this.findOne(id)
    const updatedMenu = await this._menusRepository.save(
      Object.assign(menu, updateMenuDto),
    )
    return plainToClass(MenuEntity, updatedMenu)
  }

  async remove(id: string) {
    const menu = await this.findOne(id)
    await this._menusRepository.delete(menu)
    return null
  }
}
