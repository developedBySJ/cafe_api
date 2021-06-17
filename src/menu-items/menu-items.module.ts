import { Module } from '@nestjs/common'
import { MenuItemsService } from './menu-items.service'
import { MenuItemsController } from './menu-items.controller'
import { TypeOrmModule } from '@nestjs/typeorm'
import { MenuItemEntity } from './entities/menu-item.entity'
import { MenuEntity } from 'src/menus/entities/menu.entity'
import { MenusService } from 'src/menus/menus.service'
import { MenusModule } from 'src/menus/menus.module'

@Module({
  imports: [
    TypeOrmModule.forFeature([MenuItemEntity, MenuEntity]),
    MenusModule,
  ],
  controllers: [MenuItemsController],
  providers: [MenuItemsService, MenusService],
})
export class MenuItemsModule {}
