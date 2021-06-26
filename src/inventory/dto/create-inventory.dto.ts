import {
  IsArray,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Min,
} from 'class-validator'

export class CreateInventoryDto {
  @Length(2, 16)
  name: string

  @IsInt()
  @Min(1)
  availableStock: number

  @Length(3, 300)
  @IsOptional()
  image?: string

  @IsString({ each: true })
  @IsOptional()
  tags?: string[]

  @Length(1, 16, { each: true })
  @IsOptional()
  units?: string[]

  @Length(1, 16)
  @IsOptional()
  unit?: string
}
