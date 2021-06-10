import { IsArray, IsInt, IsOptional, Length, Min } from 'class-validator'

export class CreateInventoryDto {
  @Length(2, 16)
  name: string

  @IsInt()
  @Min(1)
  availableStock: number

  @Length(3, 300)
  @IsOptional()
  image?: string

  @IsArray({ each: true })
  @IsOptional()
  tags?: string[]

  @IsArray({ each: true })
  @IsOptional()
  unit?: string[]
}
