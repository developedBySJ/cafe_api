import { NotFoundException } from '@nestjs/common'
import { UserItemType } from 'src/user-items/user-items.service'
import { NOT_FOUND_MSG } from './message.constant'

export class UserItemNotFoundException extends NotFoundException {
  constructor(type: UserItemType, id: string) {
    super(NOT_FOUND_MSG(type, id))
  }
}
