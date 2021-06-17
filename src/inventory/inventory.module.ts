import { Module } from '@nestjs/common'
import { InventoryService } from './inventory.service'
import { InventoryController } from './inventory.controller'
import { TypeOrmModule } from '@nestjs/typeorm'
import { InventoryUsageEntity } from './entities/inventory-usage.entity'
import { InventoryEntity } from './entities/inventory.entity'

@Module({
  imports: [TypeOrmModule.forFeature([InventoryEntity, InventoryUsageEntity])],
  controllers: [InventoryController],
  providers: [InventoryService],
})
export class InventoryModule {}
