import { ApiProperty } from '@nestjs/swagger'
import { ReviewEntity } from 'src/reviews/entities/review.entity'

export class MenuItemReview {
  @ApiProperty()
  reviews: ReviewEntity[]

  @ApiProperty()
  reviewCount: number

  @ApiProperty()
  ratings: number
}
