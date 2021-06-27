import { BadRequestException, Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { plainToClass } from 'class-transformer'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'
import { InSufficientStocksException } from 'src/exceptions/insufficient-stocks.exception'
import { InventoryNotFoundException } from 'src/exceptions/inventory-not-found.exception'
import { UserEntity } from 'src/users/entities/user.entity'
import { Any, In, Repository } from 'typeorm'
import { CreateInventoryDto } from './dto/create-inventory.dto'
import { InventoryFilterDto } from './dto/inventory-filter.dto'
import { UpdateInventoryDto } from './dto/update-inventory.dto'
import { UpdateStocksDto } from './dto/update-stocks.dto'
import { InventoryUsageEntity } from './entities/inventory-usage.entity'
import { InventoryEntity } from './entities/inventory.entity'

@Injectable()
export class InventoryService {
  constructor(
    @InjectRepository(InventoryEntity)
    private readonly _inventoryRepository: Repository<InventoryEntity>,
    @InjectRepository(InventoryUsageEntity)
    private readonly _inventoryUsageRepository: Repository<InventoryUsageEntity>,
  ) {}

  async create(createInventoryDto: CreateInventoryDto, user: UserEntity) {
    const _newMenu = this._inventoryRepository.create({
      ...createInventoryDto,
      createdBy: user,
    })
    const newMenu = await this._inventoryRepository.save(_newMenu)

    return newMenu
  }

  async findAll({ skip, limit, order, tags }: InventoryFilterDto) {
    const inventories = await this._inventoryRepository
      .createQueryBuilder()
      .offset(skip)
      .limit(limit)
      .orderBy('created_at', order)
      .where(
        tags ? `tags @> ARRAY[:...tags]` : '',
        tags ? { tags: tags?.split(',') || [] } : {},
      )
      .getManyAndCount()
    return inventories
  }

  async findOne(id: string) {
    const inventory = await this._inventoryRepository.findOne({ id })

    if (!inventory) throw new InventoryNotFoundException(id)

    return inventory
  }

  async updateStocks(
    id: string,
    { isAdded, qty }: UpdateStocksDto,
    user: UserEntity,
  ) {
    const inventory = await this.findOne(id)

    const newStocks = isAdded
      ? inventory.availableStock + qty
      : inventory.availableStock - qty

    if (newStocks < 0) throw new InSufficientStocksException()

    inventory.availableStock = newStocks

    const updatedInventory = await this._inventoryRepository.save(inventory)
    const usageHistory = this._inventoryUsageRepository.create({
      inventory,
      qty,
      isAdded,
      consumer: user,
      unit: inventory.unit,
    })
    await this._inventoryUsageRepository.save(usageHistory)

    return updatedInventory
  }

  async update(id: string, updateInventoryDto: UpdateInventoryDto) {
    const inventory = await this.findOne(id)

    const { availableStock, unit, units, ...other } = updateInventoryDto

    const updatedInventory = await this._inventoryRepository.save(
      Object.assign(inventory, other),
    )

    return plainToClass(InventoryEntity, updatedInventory)
  }

  async remove(id: string) {
    console.log('REMOVE')
    const inventory = await this.findOne(id)
    await this._inventoryRepository.remove(inventory)

    return null
  }
}
