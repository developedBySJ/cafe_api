import { Module } from '@nestjs/common'
import { ReviewsService } from './reviews.service'
import { ReviewsController } from './reviews.controller'
import { TypeOrmModule } from '@nestjs/typeorm'
import { ReviewEntity } from './entities/review.entity'
import { MenuItemsService } from 'src/menu-items/menu-items.service'
import { MenuItemsModule } from 'src/menu-items/menu-items.module'
import { MenuItemEntity } from 'src/menu-items/entities/menu-item.entity'

@Module({
  imports: [
    MenuItemsModule,
    TypeOrmModule.forFeature([ReviewEntity, MenuItemEntity]),
  ],
  controllers: [ReviewsController],
  providers: [ReviewsService, MenuItemsService],
})
export class ReviewsModule {}
