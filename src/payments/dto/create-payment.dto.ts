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

  @IsUUID()
  @IsOptional()
  orderId: string
}
