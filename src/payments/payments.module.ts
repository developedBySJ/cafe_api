import { Module } from '@nestjs/common'
import { PaymentsService } from './payments.service'
import { PaymentsController } from './payments.controller'
import { StripeService } from './stripe.service'
import { ConfigService } from '@nestjs/config'
import { OrdersService } from 'src/orders/orders.service'
import { TypeOrmModule } from '@nestjs/typeorm'
import { PaymentEntity } from './entities/payment.entity'
import { OrderEntity } from 'src/orders/entities/order.entity'
import { UserItemEntity } from 'src/user-items/entities/user-item.entity'
import { OrdersModule } from 'src/orders/orders.module'
import { UserItemsModule } from 'src/user-items/user-items.module'

@Module({
  controllers: [PaymentsController],
  imports: [
    TypeOrmModule.forFeature([PaymentEntity, OrderEntity, UserItemEntity]),
    OrdersModule,
    UserItemsModule,
  ],
  providers: [PaymentsService, StripeService, ConfigService, OrdersService],
})
export class PaymentsModule {}
