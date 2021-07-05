import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Query,
  ParseUUIDPipe,
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
import { ApiTags } from '@nestjs/swagger'
import { OrderFilterDto } from './dto/orders-filter.dto'
@ApiTags('Orders')
@Controller('orders')
@UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Post()
  create(@User() user: UserEntity, @Body() createOrderDto: CreateOrderDto) {
    return this.ordersService.create(createOrderDto, user)
  }

  @Get()
  findAllByUser(@User() user: UserEntity, @Query() filter: OrderFilterDto) {
    return this.ordersService.findAllByUser(user, filter)
  }

  @Get('/all')
  @Roles(UserRole.Admin)
  findAll(@Query() filter: OrderFilterDto, @Query('userId') userId?: string) {
    return this.ordersService.findAll(filter, userId)
  }

  @Get('/pending')
  findPending(@Query() filter: OrderFilterDto) {
    return this.ordersService.findAllPending(filter)
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
