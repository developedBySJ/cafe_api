import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common'
import { OrdersService } from './orders.service'
import { CreateOrderDto } from './dto/create-order.dto'
import { UpdateOrderDto } from './dto/update-order.dto'
import { JwtAuthGuard } from 'src/auth/guards'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from 'src/users/entities/user.entity'
import { RolesGuard } from 'src/common/guards/roles.guards'
import { Roles } from 'src/common/decorators'
import { UserRole } from 'src/common'
import { JwtRefreshGuard } from 'src/auth/guards/refresh.guard'

@Controller('orders')
@UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Post()
  create(@User() user: UserEntity, @Body() createOrderDto: CreateOrderDto) {
    return this.ordersService.create(createOrderDto, user)
  }

  @Get()
  findAllByUser(@User() user: UserEntity) {
    return this.ordersService.findAllByUser(user)
  }

  @Get('/all')
  @Roles(UserRole.Admin)
  findAll() {
    return this.ordersService.findAll()
  }

  @Get('/pending')
  findPending() {
    return this.ordersService.findAllPending()
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.ordersService.findOne(id)
  }

  @Patch(':id')
  @Roles(UserRole.Admin)
  update(@Param('id') id: string, @Body() updateOrderDto: UpdateOrderDto) {
    return this.ordersService.update(id, updateOrderDto)
  }

  @Delete(':id')
  @Roles(UserRole.Admin)
  remove(@Param('id') id: string) {
    return this.ordersService.remove(id)
  }
}
