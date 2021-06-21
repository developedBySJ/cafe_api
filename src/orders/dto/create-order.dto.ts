import {
  IsBoolean,
  IsEnum,
  IsInt,
  IsOptional,
  IsUUID,
  Length,
  Max,
  Min,
} from 'class-validator'
import { OrderStatus } from '../entities/order.entity'

class OrderItems {
  @IsUUID()
  id: string

  @Min(1)
  @Max(10)
  qty: number
}

export class CreateOrderDto {
  @IsInt()
  @IsOptional()
  table?: string

  @Min(1)
  total: number

  @IsEnum(OrderStatus)
  @IsOptional()
  status: OrderStatus = OrderStatus.Placed

  @Length(3, 100)
  @IsOptional()
  notes?: string

  @IsBoolean()
  @IsOptional()
  isDelivered?: boolean = false
}
