import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  UseGuards,
} from '@nestjs/common'
import { ReviewsService } from './reviews.service'
import { CreateReviewDto } from './dto/create-review.dto'
import { UpdateReviewDto } from './dto/update-review.dto'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from 'src/users/entities/user.entity'
import { JwtAuthGuard } from 'src/auth/guards'
import { ReviewFilterDto } from './dto/review-filter.dto'
import { JwtRefreshGuard } from 'src/auth/guards/refresh.guard'
import { ApiTags } from '@nestjs/swagger'

@ApiTags('Reviews')
@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @UseGuards(JwtAuthGuard, JwtRefreshGuard)
  @Post()
  create(@User() user: UserEntity, @Body() createReviewDto: CreateReviewDto) {
    return this.reviewsService.create(createReviewDto, user)
  }

  @Get()
  findAll(@Query() pageOption: ReviewFilterDto) {
    return this.reviewsService.findAll(pageOption)
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.reviewsService.findOne(id)
  }

  @UseGuards(JwtAuthGuard, JwtRefreshGuard)
  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateReviewDto: UpdateReviewDto,
    @User() curUser: UserEntity,
  ) {
    return this.reviewsService.update(id, updateReviewDto, curUser)
  }

  @UseGuards(JwtAuthGuard, JwtRefreshGuard)
  @Delete(':id')
  remove(@Param('id') id: string, @User() curUser: UserEntity) {
    return this.reviewsService.remove(id, curUser)
  }
}
