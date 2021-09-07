import { Transform } from 'class-transformer'
import { IsEnum, IsOptional } from 'class-validator'
import * as moment from 'moment'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'

export enum PaymentSortBy {
  Amount = 'amount',
  CreatedAt = 'createdAt',
  CreatedBy = 'createdBy',
  Type = 'type',
}

export class PaymentFilterDto extends PageOptionsDto {
  @IsEnum(PaymentSortBy)
  @IsOptional()
  sortBy?: PaymentSortBy

  @Transform(({ value }) =>
    moment(value).isValid() ? new Date(value) : new Date(0),
  )
  @IsOptional()
  createdAtFrom?: Date

  @Transform(({ value }) =>
    moment(value).isValid() ? new Date(value) : new Date(0),
  )
  @IsOptional()
  @IsOptional()
  createdAtTo?: Date
}
