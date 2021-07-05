import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseUUIDPipe,
  HttpStatus,
  UseGuards,
  Query,
} from '@nestjs/common'
import { MenusService } from './menus.service'
import { CreateMenuDto } from './dto/create-menu.dto'
import { UpdateMenuDto } from './dto/update-menu.dto'
import { HttpCode } from '@nestjs/common'
import { JwtAuthGuard } from 'src/auth/guards'
import { RolesGuard } from 'src/common/guards/roles.guards'
import { Roles } from 'src/common/decorators'
import { UserRole } from 'src/common'
import { MenuFilterDto } from './dto/menu-filter.dto'
import { JwtRefreshGuard } from 'src/auth/guards/refresh.guard'

@Controller('menus')
export class MenusController {
  constructor(private readonly menusService: MenusService) {}

  @Post()
  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  @UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
  async create(@Body() createMenuDto: CreateMenuDto) {
    return this.menusService.create(createMenuDto)
  }

  @Get()
  findAll(@Query() menuFilter: MenuFilterDto) {
    return this.menusService.findAll(menuFilter)
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.menusService.findOne(id)
  }

  @Patch(':id')
  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  @UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateMenuDto: UpdateMenuDto,
  ) {
    return this.menusService.update(id, updateMenuDto)
  }

  @HttpCode(HttpStatus.NO_CONTENT)
  @Delete(':id')
  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  @UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
  remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.menusService.remove(id)
  }
}
