import { NotFoundException } from '@nestjs/common'
import { NOT_FOUND_MSG } from './message.constant'

export class InventoryNotFoundException extends NotFoundException {
  constructor(id: string) {
    super(NOT_FOUND_MSG('Inventory', id))
  }
}
