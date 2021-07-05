import { IsDateString, IsEnum, IsOptional, Min } from 'class-validator'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'
import { OrderStatus } from '../entities/order.entity'

enum PaymentStatus {
  Paid = 'paid',
  UnPaid = 'unpaid',
}

export enum OrderSortBy {
  CreatedAt = 'createdAt',
  DeliveredAt = 'deliveredAt',
  Status = 'status',
}

export class OrderFilterDto extends PageOptionsDto {
  @IsEnum(OrderStatus)
  @IsOptional()
  status?: OrderStatus | 'pending'

  @IsDateString()
  @IsOptional()
  deliveredAt?: Date

  @IsDateString()
  @IsOptional()
  createdAtBefore?: Date

  @IsDateString()
  @IsOptional()
  createdAtAfter?: Date

  @Min(1)
  @IsOptional()
  totalGte?: number

  @Min(1)
  @IsOptional()
  totalLte?: number

  @IsEnum(PaymentStatus)
  @IsOptional()
  paymentStatus?: PaymentStatus

  @IsEnum(OrderSortBy)
  @IsOptional()
  sortBy?: OrderSortBy
}
