import { IsNumber, IsOptional } from 'class-validator'

export class CartMetaData {
  @IsNumber()
  @IsOptional()
  total?: number

  @IsNumber()
  @IsOptional()
  discount?: number

  @IsNumber()
  @IsOptional()
  tax?: number
}
