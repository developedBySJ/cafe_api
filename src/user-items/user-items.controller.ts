import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common'
import { UserItemsService } from './user-items.service'
import { CreateUserItemDto } from './dto/create-user-item.dto'
import { UpdateUserItemDto } from './dto/update-user-item.dto'
import { JwtAuthGuard } from 'src/auth/guards'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from 'src/users/entities/user.entity'

@UseGuards(JwtAuthGuard)
@Controller()
export class UserItemsController {
  constructor(private readonly userItemsService: UserItemsService) {}

  @Get('/cart')
  findMyCart(@User() user: UserEntity) {
    return this.userItemsService.findAll('cart', user)
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
  findMyFavorite(@User() user: UserEntity) {
    return this.userItemsService.findAll('favorite', user)
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
