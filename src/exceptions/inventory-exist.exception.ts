import { BadRequestException } from '@nestjs/common'
import { INVENTORY_EXIST_ERR_MSG } from './message.constant'

export class InventoryExistException extends BadRequestException {
  constructor(error?: string) {
    super(error || INVENTORY_EXIST_ERR_MSG)
  }
}
