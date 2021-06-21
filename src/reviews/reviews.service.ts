import { Injectable, InternalServerErrorException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { plainToClass } from 'class-transformer'
import { ReviewExistException } from 'src/exceptions/review-exist.exception'
import { ReviewNotFoundException } from 'src/exceptions/review-not-found.exception'
import { MenuItemsService } from 'src/menu-items/menu-items.service'
import { UserEntity } from 'src/users/entities/user.entity'
import { Repository } from 'typeorm'
import { CreateReviewDto } from './dto/create-review.dto'
import { UpdateReviewDto } from './dto/update-review.dto'
import { ReviewEntity } from './entities/review.entity'

@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(ReviewEntity)
    private readonly _reviewsRepository: Repository<ReviewEntity>,
    private readonly _menuItemService: MenuItemsService,
  ) {}

  async create(createReviewDto: CreateReviewDto, user: UserEntity) {
    const menuItem = await this._menuItemService.findOne(
      createReviewDto.menuItem,
    )

    const _review = this._reviewsRepository.create({
      ...createReviewDto,
      menuItem,
      user,
    })

    try {
      const review = await this._reviewsRepository.save(_review)

      return review
    } catch (error) {
      if (error?.code === '23505') throw new ReviewExistException()

      throw new InternalServerErrorException()
    }
  }

  async findAll(menuItemId: string) {
    const menuItem = await this._menuItemService.findOne(menuItemId)

    const reviews = await this._reviewsRepository.find({ menuItem })

    return reviews
  }

  async findOne(id: string) {
    const review = await this._reviewsRepository.findOne(id)

    if (!review) throw new ReviewNotFoundException(id)

    return review
  }

  async update(id: string, { menuItem, ...other }: UpdateReviewDto) {
    const review = await this.findOne(id)

    const updatedReview = await this._reviewsRepository.save(
      Object.assign(review, other),
    )

    return plainToClass(ReviewEntity, updatedReview)
  }

  async remove(id: string) {
    const review = await this.findOne(id)

    await this._reviewsRepository.remove(review)

    return null
  }
}
