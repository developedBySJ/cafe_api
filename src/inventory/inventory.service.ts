import { Injectable, NotFoundException } from '@nestjs/common'
import { Repository } from 'typeorm'
import { CreateInventoryDto } from './dto/create-inventory.dto'
import { UpdateInventoryDto } from './dto/update-inventory.dto'
import { InventoryUsageEntity } from './entities/inventory-usage.entity'
import { InventoryEntity } from './entities/inventory.entity'

@Injectable()
export class InventoryService {
  constructor(
    private readonly _inventoryRepository: Repository<InventoryEntity>,
    private readonly _inventoryUsageRepository: Repository<InventoryUsageEntity>,
  ) {}
  async create(createInventoryDto: CreateInventoryDto) {
    const _newMenu = this._inventoryRepository.create(createInventoryDto)
    const newMenu = await this._inventoryRepository.save(_newMenu)

    return newMenu
  }

  async findAll() {
    const inventories = await this._inventoryRepository.find()
    return inventories
  }

  async findOne(id: string) {
    const inventory = await this._inventoryRepository.findOne({ id })
    if (!inventory) throw new NotFoundException()
    return inventory
  }

  update(id: number, updateInventoryDto: UpdateInventoryDto) {
    return `This action updates a #${id} inventory`
  }

  remove(id: number) {
    return `This action removes a #${id} inventory`
  }
}
