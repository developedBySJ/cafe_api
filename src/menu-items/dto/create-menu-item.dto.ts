import {
  IsBoolean,
  IsOptional,
  IsPositive,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
} from 'class-validator'

export class CreateMenuItemDto {
  @Length(3, 50)
  title: string

  @Length(3, 100)
  @IsOptional()
  subTitle?: string

  @IsString({ each: true })
  @IsOptional()
  images: string[]

  @IsBoolean()
  isAvailable: boolean = false

  @IsBoolean()
  isVeg: boolean = false

  @IsPositive()
  price: number

  @Min(0)
  @Max(99)
  discount: number = 0

  @Length(3, 1000)
  @IsOptional()
  description?: string

  @IsPositive()
  @IsOptional()
  prepTime?: number

  @IsUUID()
  menu: string
}
