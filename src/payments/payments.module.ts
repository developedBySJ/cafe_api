import { Module } from '@nestjs/common'
import { PaymentsService } from './payments.service'
import { PaymentsController } from './payments.controller'
import { StripeService } from './stripe.service'
import { ConfigService } from '@nestjs/config'

@Module({
  controllers: [PaymentsController],
  providers: [PaymentsService, StripeService, ConfigService],
})
export class PaymentsModule {}
