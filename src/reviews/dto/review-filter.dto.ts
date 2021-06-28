import { IsEnum, IsOptional, IsUUID, Max, Min } from 'class-validator'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'

export enum ReviewSortBy {
  Ratings = 'ratings',
  CreatedAt = 'createdAt',
}

export class ReviewFilterDto extends PageOptionsDto {
  @IsUUID()
  menuItemId: string

  @Min(0)
  @Max(5)
  @IsOptional()
  ratings: number

  @IsEnum(ReviewSortBy)
  @IsOptional()
  sortBy: ReviewSortBy
}
