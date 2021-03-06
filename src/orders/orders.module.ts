import { forwardRef, Module } from '@nestjs/common'
import { OrdersService } from './orders.service'
import { OrdersController } from './orders.controller'
import { TypeOrmModule } from '@nestjs/typeorm'
import { OrderEntity } from './entities/order.entity'
import { UserItemsModule } from 'src/user-items/user-items.module'
import { UserItemsService } from 'src/user-items/user-items.service'
import { UserItemEntity } from 'src/user-items/entities/user-item.entity'
import { OrdersEmailService } from 'src/Mail/orders-email.service'

@Module({
  imports: [
    UserItemsModule,
    TypeOrmModule.forFeature([OrderEntity, UserItemEntity]),
  ],
  controllers: [OrdersController],
  providers: [OrdersService, UserItemsService, OrdersEmailService],
})
export class OrdersModule {}
