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
import { UserItemsService } from './user-items.service'
import { CreateUserItemDto } from './dto/create-user-item.dto'
import { UpdateUserItemDto } from './dto/update-user-item.dto'
import { JwtAuthGuard } from 'src/auth/guards'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from 'src/users/entities/user.entity'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'
import { JwtRefreshGuard } from 'src/auth/guards/refresh.guard'
import { ApiTags } from '@nestjs/swagger'

@ApiTags('User Items')
@UseGuards(JwtAuthGuard, JwtRefreshGuard)
@Controller()
export class UserItemsController {
  constructor(private readonly userItemsService: UserItemsService) {}

  @Get('/cart')
  findMyCart(@Query() pageOption: PageOptionsDto, @User() user: UserEntity) {
    return this.userItemsService.findAll('cart', pageOption, user)
  }

  @Post('/cart')
  createCart(
    @User() user: UserEntity,
    @Body() createUserItemDto: CreateUserItemDto,
  ) {
    return this.userItemsService.create(createUserItemDto, user)
  }

  @Patch('/cart/:id')
  updateCartQty(
    @User() user: UserEntity,
    @Param('id') id: string,
    @Body() updateUserItemDto: UpdateUserItemDto,
  ) {
    return this.userItemsService.update(id, updateUserItemDto, user)
  }

  @Delete('/cart/:id')
  removeFromCart(@User() user: UserEntity, @Param('id') id: string) {
    return this.userItemsService.remove(id, 'cart', user)
  }

  @Delete('/cart')
  clearCart(@User() user: UserEntity) {
    return this.userItemsService.removeAll('cart', user)
  }

  @Get('/favorite')
  findMyFavorite(
    @Query() pageOption: PageOptionsDto,
    @User() user: UserEntity,
  ) {
    return this.userItemsService.findAll('favorite', pageOption, user)
  }

  @Post('/favorite')
  createFavorite(
    @User() user: UserEntity,
    @Body() createUserItemDto: CreateUserItemDto,
  ) {
    return this.userItemsService.create(createUserItemDto, user)
  }

  @Delete('/favorite/:id')
  removeFromFavorite(@User() user: UserEntity, @Param('id') id: string) {
    return this.userItemsService.remove(id, 'favorite', user)
  }

  @Delete('/favorite')
  clearFavorite(@User() user: UserEntity) {
    return this.userItemsService.removeAll('favorite', user)
  }
}
