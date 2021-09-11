import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsUUID,
  IsOptional,
} from 'class-validator'

export class CreatePaymentDto {
  @IsString()
  @IsNotEmpty()
  paymentMethodId: string

  @IsNumber()
  amount: number

  @IsUUID(4)
  orderId: string
}
export class CreateCashPaymentDto {
  @IsString()
  @IsNotEmpty()
  @IsOptional()
  description?: string

  @IsNumber()
  amount: number

  @IsUUID(4)
  orderId: string
}
