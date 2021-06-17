import { BadRequestException } from '@nestjs/common'
import { MENU_EXIST_ERR_MSG } from './message.constant'

export class MenuExistException extends BadRequestException {
  constructor(error?: string) {
    super(error || MENU_EXIST_ERR_MSG)
  }
}
