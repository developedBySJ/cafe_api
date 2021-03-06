import {
  IsArray,
  IsBoolean,
  IsOptional,
  IsPositive,
  IsString,
  IsUUID,
  length,
  Length,
  Max,
  Min,
} from 'class-validator'

export class CreateMenuItemDto {
  @Length(3, 100)
  title: string

  @Length(3, 100)
  @IsOptional()
  subTitle?: string

  @IsString({ each: true })
  @IsOptional()
  images: string[]

  @IsBoolean()
  isAvailable = false

  @IsBoolean()
  isVeg = false

  @IsPositive()
  price: number

  @Min(0)
  @Max(99)
  discount = 0

  @Length(3, 1000)
  @IsOptional()
  description?: string

  @IsPositive()
  @IsOptional()
  prepTime?: number

  @IsString({ each: true })
  @IsArray()
  @IsOptional()
  ingredients?: string[]

  @IsUUID()
  menu: string
}
