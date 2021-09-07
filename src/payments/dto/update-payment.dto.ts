import { PickType } from '@nestjs/swagger'
import { CreatePaymentDto } from './create-payment.dto'

export class UpdatePaymentDto extends PickType(CreatePaymentDto, ['orderId']) {}
