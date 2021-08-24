import { BadRequestException } from '@nestjs/common'
import { MENU_ITEM_NOT_AVAILABLE } from '.'

export class MenuItemNotAvailableException extends BadRequestException {
  constructor() {
    super(MENU_ITEM_NOT_AVAILABLE)
  }
}
