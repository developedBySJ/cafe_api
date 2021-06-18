import { Injectable } from '@nestjs/common';
import { CreateUserItemDto } from './dto/create-user-item.dto';
import { UpdateUserItemDto } from './dto/update-user-item.dto';

@Injectable()
export class UserItemsService {
  create(createUserItemDto: CreateUserItemDto) {
    return 'This action adds a new userItem';
  }

  findAll() {
    return `This action returns all userItems`;
  }

  findOne(id: number) {
    return `This action returns a #${id} userItem`;
  }

  update(id: number, updateUserItemDto: UpdateUserItemDto) {
    return `This action updates a #${id} userItem`;
  }

  remove(id: number) {
    return `This action removes a #${id} userItem`;
  }
}
