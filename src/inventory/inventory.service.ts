import { Injectable, NotFoundException } from '@nestjs/common'
import { INSUFFICIENT_STOCKS_ERR_MSG } from 'src/exceptions'
import { InSufficientStocksException } from 'src/exceptions/insufficient-stocks.exception'
import { InventoryNotFoundException } from 'src/exceptions/inventory-not-found.exception'
import { Repository } from 'typeorm'
import { CreateInventoryDto } from './dto/create-inventory.dto'
import { UpdateInventoryDto } from './dto/update-inventory.dto'
import { UpdateStocksDto } from './dto/update-stocks.dto'
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
    if (!inventory) throw new InventoryNotFoundException(id)
    return inventory
  }
  async updateStocks(id: string, { isAdded, qty }: UpdateStocksDto) {
    const inventory = await this._inventoryRepository.findOne({ id })
    if (!inventory) throw new InventoryNotFoundException(id)

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
    })
    await this._inventoryUsageRepository.save(usageHistory)

    return updatedInventory
  }

  update(id: string, updateInventoryDto: UpdateInventoryDto) {
    return `This action updates a #${id} inventory`
  }

  remove(id: number) {
    return `This action removes a #${id} inventory`
  }
}
