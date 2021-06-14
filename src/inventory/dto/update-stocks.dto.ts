import { IsBoolean, IsPositive, IsUUID } from 'class-validator'

export class UpdateStocksDto {
  @IsPositive()
  qty: number

  @IsBoolean()
  isAdded: boolean
}
