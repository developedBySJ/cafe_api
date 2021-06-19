import { IsOptional, IsUUID, Length, Max, Min } from 'class-validator'
import { UserEntity } from 'src/users/entities/user.entity'

export class CreateReviewDto {
  @IsUUID()
  menuItem: UserEntity

  @Length(3, 50)
  title: string

  @Length(3, 200)
  comment: string

  @Length(3, 300)
  @IsOptional()
  image?: string

  @Min(1)
  @Max(5)
  ratings: number
}
