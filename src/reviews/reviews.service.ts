import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { MenuItemEntity } from 'src/menu-items/entities/menu-item.entity'
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

    const review = await this._reviewsRepository.save(_review)

    return review
  }

  findAll() {
    return `This action returns all reviews`
  }

  findOne(id: number) {
    return `This action returns a #${id} review`
  }

  update(id: number, updateReviewDto: UpdateReviewDto) {
    return `This action updates a #${id} review`
  }

  remove(id: number) {
    return `This action removes a #${id} review`
  }
}
