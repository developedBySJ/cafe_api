import { ParseIntPipe, UsePipes } from '@nestjs/common'
import { Transform } from 'class-transformer'
import {
  IsBoolean,
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  Min,
} from 'class-validator'

import { Sort } from 'src/common'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'

enum MenuItemSortBy {
  Price = 'price',
  Discount = 'discount',
  PrepTime = 'prepTime',
  IsAvailable = 'isAvailable',
  CreatedAt = 'createdAt',
}

export class MenuItemsFilterDto extends PageOptionsDto {
  @IsOptional()
  search?: string

  @IsBoolean()
  @Transform(({ value }) => ['1', 1, 'true', true].includes(value))
  @IsOptional()
  readonly isAvailable: any

  @IsBoolean()
  @Transform(({ value }) => ['1', 1, 'true', true].includes(value))
  @IsOptional()
  readonly isVeg: any

  @Min(1)
  @IsInt()
  @IsOptional()
  readonly priceGte?: number

  @Min(1)
  @IsOptional()
  readonly priceLte?: number

  @Min(0)
  @Max(100)
  @IsInt()
  @IsOptional()
  readonly discount?: number

  @Min(0)
  @IsOptional()
  readonly prepTime?: number

  @IsUUID()
  @IsOptional()
  readonly menu: string

  @IsEnum(MenuItemSortBy)
  @IsOptional()
  readonly sortBy: MenuItemSortBy = MenuItemSortBy.CreatedAt

  @IsEnum(Sort)
  @IsOptional()
  readonly sort?: Sort = Sort.DESC

  @IsString()
  @IsOptional()
  readonly ingredients?: string
}
