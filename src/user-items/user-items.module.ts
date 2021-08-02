import { Module } from '@nestjs/common'
import { UserItemsService } from './user-items.service'
import { UserItemsController } from './user-items.controller'
import { TypeOrmModule } from '@nestjs/typeorm'
import { UserItemEntity } from './entities/user-item.entity'
import { MenuItemsModule } from 'src/menu-items/menu-items.module'
import { MenuItemsService } from 'src/menu-items/menu-items.service'
import { MenuItemEntity } from 'src/menu-items/entities/menu-item.entity'
import { ReviewEntity } from 'src/reviews/entities/review.entity'

@Module({
  imports: [
    TypeOrmModule.forFeature([UserItemEntity, MenuItemEntity, ReviewEntity]),
    MenuItemsModule,
  ],
  controllers: [UserItemsController],
  providers: [UserItemsService, MenuItemsService],
  exports: [UserItemsService, MenuItemsService],
})
export class UserItemsModule {}
