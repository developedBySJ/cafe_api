import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { PaymentNotFoundException } from 'src/exceptions/payment-not-found.exception'
import { OrderEntity } from 'src/orders/entities/order.entity'
import { OrdersService } from 'src/orders/orders.service'
import { UserEntity } from 'src/users/entities/user.entity'
import { UtilsService } from 'src/utils/services'
import { Between, LessThanOrEqual, MoreThanOrEqual, Repository } from 'typeorm'
import {
  CreateCashPaymentDto,
  CreatePaymentDto,
} from './dto/create-payment.dto'
import { PaymentFilterDto } from './dto/payment-filter.dto'
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
    @InjectRepository(OrderEntity)
    private readonly _orderRepository: Repository<OrderEntity>,
  ) {}

  async create(createPaymentDto: CreatePaymentDto, user: UserEntity) {
    const { amount, orderId, paymentMethodId } = createPaymentDto

    const description = `Payment for order #${orderId}`

    const res = await this._stripeService.charge(
      amount,
      paymentMethodId,
      description,
    )

    const order = orderId
      ? await this._orderService.findOne(orderId)
      : undefined

    const _newPayment = this._paymentRepository.create({
      amount,
      description,
      type: PaymentType.Card,
      referenceId: res.id,
      createdBy: user,
      order,
    })
    const newPayment = await this._paymentRepository.save(_newPayment)

    if (order) {
      order.payment = newPayment.id as any
      await this._orderRepository.save(order)
    }

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

    if (order) {
      order.payment = newPayment.id as any
      console.log(order.payment)
      await this._orderRepository.save(order)
    }

    return newPayment
  }

  async getOverview() {
    const totalPayment = (
      await this._paymentRepository.query(
        `SELECT SUM(amount)/100 as count FROM payment WHERE created_at >= (NOW() - INTERVAL '1 month' );`,
      )
    )[0]?.count as number

    const paymentSummery = await this._paymentRepository.query(
      `SELECT SUM(amount)/100 as count,extract('day' from created_at) as time FROM payment
      WHERE created_at >= (NOW() - INTERVAL '1 month' )
      GROUP BY extract('day' from created_at)
      ORDER BY extract('day' from created_at) ASC;`,
    )
    const data = {
      count: {
        totalPayment,
      },
      summery: {
        paymentSummery,
      },
    }
    return data
  }

  async findAll(filter: PaymentFilterDto) {
    console.log({ filter })
    const {
      skip,
      limit,
      createdAtFrom,
      createdAtTo,
      sort,
      sortBy,
      page,
    } = filter
    const payments = await this._paymentRepository.findAndCount({
      loadRelationIds: true,
      skip,
      take: limit,
      order: {
        ...(sortBy && { [sortBy]: sort }),
      },
      where: {
        createdAt: Between(
          createdAtFrom || new Date(0),
          createdAtTo || new Date(),
        ),
      },
    })
    const paginationResponse = UtilsService.paginationResponse({
      baseUrl: '',
      curPage: page,
      data: payments,
      limit,
      query: {
        sortBy,
        createdAtFrom,
        createdAtTo,
        sort,
      },
    })

    return paginationResponse
  }

  findOne(id: string) {
    const payment = this._paymentRepository.findOne(id)

    if (!payment) throw new PaymentNotFoundException(id)

    return payment
  }

  async update(id: string, updatePaymentDto: UpdatePaymentDto) {
    const payment = await this.findOne(id)

    const { orderId } = updatePaymentDto
    const order = orderId && (await this._orderService.findOne(orderId))
    payment.order = order

    const updatedPayment = await this._paymentRepository.save(payment)

    return updatedPayment
  }

  async remove(id: string) {
    const payment = await this.findOne(id)

    await this._paymentRepository.softRemove(payment)

    return null
  }
}
