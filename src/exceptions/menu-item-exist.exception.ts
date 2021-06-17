import { BadRequestException } from '@nestjs/common'
import { MENU_ITEM_EXIST_ERR_MSG } from './message.constant'

export class MenuItemExistException extends BadRequestException {
  constructor(error?: string) {
    super(error || MENU_ITEM_EXIST_ERR_MSG)
  }
}
