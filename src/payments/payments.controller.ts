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
} from '@nestjs/common'
import { PaymentsService } from './payments.service'
import {
  CreateCashPaymentDto,
  CreatePaymentDto,
} from './dto/create-payment.dto'
import { UpdatePaymentDto } from './dto/update-payment.dto'
import { ApiTags } from '@nestjs/swagger'
import { JwtAuthGuard } from 'src/auth/guards'
import { RolesGuard } from 'src/common/guards/roles.guards'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from 'src/users/entities/user.entity'
import { UserRole } from 'src/common'
import { Roles } from 'src/common/decorators'
import { PaymentFilterDto } from './dto/payment-filter.dto'

@ApiTags('Payments')
@Controller('payments')
@UseGuards(JwtAuthGuard, RolesGuard)
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post()
  create(@Body() createPaymentDto: CreatePaymentDto, @User() user: UserEntity) {
    return this.paymentsService.create(createPaymentDto, user)
  }

  @Post('cash')
  @Roles(UserRole.Admin, UserRole.Cashier, UserRole.Manager)
  createCash(
    @Body() createCashPaymentDto: CreateCashPaymentDto,
    @User() user: UserEntity,
  ) {
    return this.paymentsService.createCashPayment(createCashPaymentDto, user)
  }

  @Get()
  findAll(@Query() paymentFilter: PaymentFilterDto) {
    return this.paymentsService.findAll(paymentFilter)
  }

  @Roles(UserRole.Admin, UserRole.Manager)
  @Get('/overview')
  getOverview() {
    return this.paymentsService.getOverview()
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.paymentsService.findOne(id)
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updatePaymentDto: UpdatePaymentDto) {
    return this.paymentsService.update(id, updatePaymentDto)
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.paymentsService.remove(id)
  }
}
