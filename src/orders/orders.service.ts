import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { UserRole } from 'src/common'
import { UserItemEntity } from 'src/user-items/entities/user-item.entity'
import { UserItemsService } from 'src/user-items/user-items.service'
import { UserEntity } from 'src/users/entities/user.entity'
import { IsNull, LessThan, Not, Repository } from 'typeorm'

import { CreateOrderDto } from './dto/create-order.dto'
import { UpdateOrderDto } from './dto/update-order.dto'
import { OrderEntity, OrderStatus } from './entities/order.entity'

@Injectable()
export class OrdersService {
  constructor(
    private readonly _userItemsService: UserItemsService,
    @InjectRepository(OrderEntity)
    private readonly _orderRepository: Repository<OrderEntity>,
    @InjectRepository(UserItemEntity)
    private readonly _userItemsRepository: Repository<UserItemEntity>,
  ) {}
  async create(createOrderDto: CreateOrderDto, user: UserEntity) {
    const cartItems = await this._userItemsRepository.find({
      where: { user, qty: Not(IsNull()) },
    })

    if (!cartItems.length)
      throw new BadRequestException('Add At least one product')

    const total = cartItems.reduce(
      (acc, cur) => acc + cur.qty * cur.menuItem.price,
      0,
    )

    if (total !== createOrderDto.total)
      throw new BadRequestException('order total not matching')

    const deliveredAt = createOrderDto.isDelivered ? new Date() : null
    const status =
      user.role === UserRole.Customer
        ? OrderStatus.Placed
        : createOrderDto.status

    const _newOrder = this._orderRepository.create({
      ...createOrderDto,
      user,
      total,
      orderItems: cartItems,
      deliveredAt,
      status,
    })

    const newOrder = await this._orderRepository.save(_newOrder)

    await this._userItemsService.removeAll('cart', user)

    return newOrder
  }

  async findAllByUser(user: UserEntity) {
    const orders = await this._orderRepository.find({ user })
    return orders
  }

  async findAll() {
    const orders = await this._orderRepository.find()
    return orders
  }

  async findAllPending() {
    const orders = await this._orderRepository.find({
      status: LessThan(OrderStatus.Delivered),
    })
    return orders
  }

  async findOne(id: string) {
    const order = await this._orderRepository.findOne(id)

    if (!order) throw new NotFoundException()

    return order
  }

  async update(id: string, { status, isDelivered }: UpdateOrderDto) {
    const order = await this.findOne(id)

    if (![OrderStatus.Cancelled, OrderStatus.Delivered].includes(order.status))
      order.status = status

    if (
      status === OrderStatus.Delivered ||
      (!order.deliveredAt && isDelivered)
    ) {
      order.deliveredAt = new Date()
      order.status = OrderStatus.Delivered
    }

    const updatedOrder = await this._orderRepository.save(order)

    return updatedOrder
  }

  async remove(id: string) {
    const order = await this.findOne(id)

    await this._orderRepository.softRemove(order)

    return null
  }
}
