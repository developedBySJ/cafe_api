import { IsOptional, IsPositive, IsUUID, Max, Min } from 'class-validator'

export class CreateUserItemDto {
  @IsUUID()
  menuItem: string

  @Min(0)
  @Max(10)
  @IsOptional()
  qty?: number
}
