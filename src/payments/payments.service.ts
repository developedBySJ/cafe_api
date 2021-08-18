import { Injectable } from '@nestjs/common'
import { UserEntity } from 'src/users/entities/user.entity'
import { CreatePaymentDto } from './dto/create-payment.dto'
import { UpdatePaymentDto } from './dto/update-payment.dto'
import { StripeService } from './stripe.service'

@Injectable()
export class PaymentsService {
  constructor(private readonly _stripeService: StripeService) {}
  create(createPaymentDto: CreatePaymentDto, user: UserEntity) {
    const { amount, orderId, paymentMethodId } = createPaymentDto
    const description = `Payment for order #${orderId}`
    return this._stripeService.charge(amount, paymentMethodId, description)
  }

  findAll() {
    return `This action returns all payments`
  }

  findOne(id: number) {
    return `This action returns a #${id} payment`
  }

  update(id: number, updatePaymentDto: UpdatePaymentDto) {
    return `This action updates a #${id} payment`
  }

  remove(id: number) {
    return `This action removes a #${id} payment`
  }
}
