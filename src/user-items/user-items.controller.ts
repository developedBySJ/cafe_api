import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { UserItemsService } from './user-items.service';
import { CreateUserItemDto } from './dto/create-user-item.dto';
import { UpdateUserItemDto } from './dto/update-user-item.dto';

@Controller('user-items')
export class UserItemsController {
  constructor(private readonly userItemsService: UserItemsService) {}

  @Post()
  create(@Body() createUserItemDto: CreateUserItemDto) {
    return this.userItemsService.create(createUserItemDto);
  }

  @Get()
  findAll() {
    return this.userItemsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.userItemsService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateUserItemDto: UpdateUserItemDto) {
    return this.userItemsService.update(+id, updateUserItemDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.userItemsService.remove(+id);
  }
}
