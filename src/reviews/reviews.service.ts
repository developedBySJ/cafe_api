import {
  ForbiddenException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { plainToClass } from 'class-transformer'
import { UserRole } from 'src/common'
import { ReviewExistException } from 'src/exceptions/review-exist.exception'
import { ReviewNotFoundException } from 'src/exceptions/review-not-found.exception'
import { MenuItemsService } from 'src/menu-items/menu-items.service'
import { UserEntity } from 'src/users/entities/user.entity'
import { UtilsService } from 'src/utils/services'
import { Repository } from 'typeorm'
import { CreateReviewDto } from './dto/create-review.dto'
import { ReviewFilterDto } from './dto/review-filter.dto'
import { UpdateReviewDto } from './dto/update-review.dto'
import { ReviewEntity } from './entities/review.entity'

@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(ReviewEntity)
    private readonly _reviewsRepository: Repository<ReviewEntity>,
    private readonly _menuItemService: MenuItemsService,
  ) {}

  private async verify(id: string, curUser: UserEntity) {
    const review = await this.findOne(id)
    const access = [UserRole.Admin, UserRole.Manager]
    if (
      !UtilsService.hasAbility({
        doc: review,
        ownerKey: 'createdBy',
        user: curUser,
        access,
      })
    )
      throw new ForbiddenException()

    return review
  }

  async create(createReviewDto: CreateReviewDto, user: UserEntity) {
    const menuItem = await this._menuItemService.findOne(
      createReviewDto.menuItem,
    )

    const _review = this._reviewsRepository.create({
      ...createReviewDto,
      menuItem,
      createdBy: user,
    })

    try {
      const review = await this._reviewsRepository.save(_review)

      return review
    } catch (error) {
      if (error?.code === '23505') throw new ReviewExistException()

      throw new InternalServerErrorException()
    }
  }

  async findAll({
    sort,
    skip,
    limit,
    ratings,
    sortBy,
    menuItemId,
    page,
    user,
  }: ReviewFilterDto) {
    const menuItem =
      menuItemId && (await this._menuItemService.findOne(menuItemId))

    const reviews = await this._reviewsRepository.findAndCount({
      skip,
      take: limit,
      order: { ...(sortBy && { [sortBy]: sort }) },
      where: {
        ...(menuItem && { menuItem }),
        ...(ratings && { ratings }),
        ...(user && { createdBy: user }),
      },
      relations: ['menuItem', 'createdBy'],
    })

    const paginationResponse = UtilsService.paginationResponse({
      baseUrl: '',
      curPage: page,
      data: reviews,
      limit,
      query: {
        sortBy,
        menuItemId,
        ratings,
        sort,
      },
    })

    return paginationResponse
  }

  async findOne(id: string, curUser?: UserEntity) {
    const review = await this._reviewsRepository.findOne(
      {
        id,
        ...(curUser && { createdBy: curUser }),
      },
      { relations: ['menuItem', 'createdBy'] },
    )

    if (!review) throw new ReviewNotFoundException(id)

    return review
  }

  async update(
    id: string,
    { menuItem, ...other }: UpdateReviewDto,
    curUser: UserEntity,
  ) {
    const review = await this.verify(id, curUser)

    const updatedReview = await this._reviewsRepository.save(
      Object.assign(review, other),
    )

    return plainToClass(ReviewEntity, updatedReview)
  }

  async remove(id: string, curUser: UserEntity) {
    const review = await this.verify(id, curUser)

    await this._reviewsRepository.remove(review)

    return null
  }
}
