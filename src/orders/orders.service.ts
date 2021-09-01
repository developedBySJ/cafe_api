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
import { UtilsService } from 'src/utils/services'
import {
  Between,
  Equal,
  FindOperator,
  IsNull,
  LessThan,
  LessThanOrEqual,
  MoreThanOrEqual,
  Not,
  Repository,
} from 'typeorm'

import { CreateOrderDto } from './dto/create-order.dto'
import { OrderFilterDto } from './dto/orders-filter.dto'
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

  private _getQuery(filter: OrderFilterDto) {
    const {
      createdAtAfter,
      createdAtBefore,
      paymentStatus,
      skip,
      totalGte,
      totalLte,
      deliveredAt,
      limit,
      page,
      sort,
      sortBy,
      status,
    } = filter

    let createdAtFilter: { createdAt: FindOperator<number> } | {} = {}
    if (createdAtBefore && createdAtAfter) {
      createdAtFilter = { createdAt: Between(createdAtAfter, createdAtBefore) }
    } else if (createdAtAfter) {
      createdAtFilter = { createdAt: MoreThanOrEqual(createdAtAfter) }
    } else if (createdAtBefore) {
      createdAtFilter = { createdAt: LessThanOrEqual(createdAtBefore) }
    }

    const paymentFilter = paymentStatus ? { payment: Not(IsNull()) } : {}

    let totalFilter: { total: FindOperator<number> } | {} = {}
    if (totalLte && totalGte) {
      totalFilter = { total: Between(totalGte, totalLte) }
    } else if (totalGte) {
      totalFilter = { total: MoreThanOrEqual(totalGte) }
    } else if (totalLte) {
      totalFilter = { total: LessThanOrEqual(totalLte) }
    }

    const deliveredAtFilter = deliveredAt && { deliveredAt: Equal(deliveredAt) }

    const sortByFilter = sortBy && { order: { [sortBy]: sort } }

    const paginationFilter = { skip, take: limit }

    const statusFilter =
      status > 0 && status === 'pending'
        ? { status: LessThan(OrderStatus.Delivered) }
        : status
          ? { status }
          : {}

    const orderFilter = {
      createdAtFilter,
      paymentFilter,
      totalFilter,
      deliveredAtFilter,
      sortByFilter,
      paginationFilter,
      statusFilter,
    }
    return orderFilter
  }

  async create(createOrderDto: CreateOrderDto, user: UserEntity) {
    const cartItems = await this._userItemsRepository.find({
      where: { createdBy: user, qty: Not(IsNull()) },
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

  async findAllByUser(user: UserEntity, filter: OrderFilterDto) {
    return this.findAll(filter, user.id)
  }

  async findAll(filter: OrderFilterDto, userId?: string) {
    const {
      createdAtFilter,
      deliveredAtFilter,
      paginationFilter,
      paymentFilter,
      sortByFilter,
      statusFilter,
      totalFilter,
    } = this._getQuery(filter)

    const orders = await this._orderRepository.findAndCount({
      where: {
        ...(userId && { user: userId }),
        ...statusFilter,
        ...createdAtFilter,
        ...paymentFilter,
        ...deliveredAtFilter,
        ...totalFilter,
      },
      loadRelationIds: true,
      ...sortByFilter,
      ...paginationFilter,
    })
    const { skip, ...query } = filter
    const paginationResponse = UtilsService.paginationResponse({
      baseUrl: '',
      curPage: filter.page,
      data: orders,
      limit: filter.limit,
      query,
    })

    return paginationResponse
  }

  async findAllPending(filter: OrderFilterDto) {
    const pendingFilter = Object.assign(filter, { status: 'pending' })
    return this.findAll(pendingFilter)
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
