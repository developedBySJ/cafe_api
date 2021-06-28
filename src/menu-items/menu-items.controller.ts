import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Query,
} from '@nestjs/common'
import { MenuItemsService } from './menu-items.service'
import { CreateMenuItemDto } from './dto/create-menu-item.dto'
import { UpdateMenuItemDto } from './dto/update-menu-item.dto'
import { JwtAuthGuard } from 'src/auth/guards'
import { RolesGuard } from 'src/common/guards/roles.guards'
import { Roles } from 'src/common/decorators'
import { UserRole } from 'src/common'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from 'src/users/entities/user.entity'
import { MenuItemsFilterDto } from './dto/menu-items-filter.dto'

@Controller('menu-items')
export class MenuItemsController {
  constructor(private readonly menuItemsService: MenuItemsService) {}

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  create(
    @User() user: UserEntity,
    @Body() createMenuItemDto: CreateMenuItemDto,
  ) {
    return this.menuItemsService.create(createMenuItemDto, user)
  }

  @Get()
  findAll(@Query() menuItemFilter: MenuItemsFilterDto) {
    console.log(menuItemFilter)
    return this.menuItemsService.findAll(menuItemFilter)
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.menuItemsService.findOne(id)
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateMenuItemDto: UpdateMenuItemDto,
  ) {
    return this.menuItemsService.update(id, updateMenuItemDto)
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.menuItemsService.remove(id)
  }
}
