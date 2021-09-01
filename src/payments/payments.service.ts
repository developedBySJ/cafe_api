import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { OrdersService } from 'src/orders/orders.service'
import { UserEntity } from 'src/users/entities/user.entity'
import { Repository } from 'typeorm'
import {
  CreateCashPaymentDto,
  CreatePaymentDto,
} from './dto/create-payment.dto'
import { UpdatePaymentDto } from './dto/update-payment.dto'
import { PaymentEntity, PaymentType } from './entities/payment.entity'
import { StripeService } from './stripe.service'

@Injectable()
export class PaymentsService {
  constructor(
    private readonly _stripeService: StripeService,
    private readonly _orderService: OrdersService,
    @InjectRepository(PaymentEntity)
    private readonly _paymentRepository: Repository<PaymentEntity>,
  ) {}

  async create(createPaymentDto: CreatePaymentDto, user: UserEntity) {
    const { amount, orderId, paymentMethodId } = createPaymentDto

    const description = `Payment for order #${orderId}`

    const res = await this._stripeService.charge(
      amount,
      paymentMethodId,
      description,
    )

    const order = orderId && (await this._orderService.findOne(orderId))

    const _newPayment = this._paymentRepository.create({
      amount,
      description,
      type: PaymentType.Card,
      referenceId: res.id,
      createdBy: user,
      order,
    })

    const newPayment = await this._paymentRepository.save(_newPayment)

    return newPayment
  }

  async createCashPayment(
    createPaymentDto: CreateCashPaymentDto,
    user: UserEntity,
  ) {
    const { amount, orderId, description } = createPaymentDto
    const order = orderId && (await this._orderService.findOne(orderId))

    const _newPayment = this._paymentRepository.create({
      amount,
      description,
      type: PaymentType.Cash,
      createdBy: user,
      order,
    })

    const newPayment = await this._paymentRepository.save(_newPayment)

    return newPayment
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
