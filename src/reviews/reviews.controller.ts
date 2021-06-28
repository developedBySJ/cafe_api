import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  ParseUUIDPipe,
  UseGuards,
} from '@nestjs/common'
import { ReviewsService } from './reviews.service'
import { CreateReviewDto } from './dto/create-review.dto'
import { UpdateReviewDto } from './dto/update-review.dto'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from 'src/users/entities/user.entity'
import { JwtAuthGuard } from 'src/auth/guards'
import { ReviewFilterDto } from './dto/review-filter.dto'

@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @UseGuards(JwtAuthGuard)
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

  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  update(@Param('id') id: string, @Body() updateReviewDto: UpdateReviewDto) {
    return this.reviewsService.update(id, updateReviewDto)
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.reviewsService.remove(id)
  }
}
