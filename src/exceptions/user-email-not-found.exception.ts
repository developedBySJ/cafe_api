import { NotFoundException } from '@nestjs/common'
import { EMAIL_NOT_EXIST_ERR_MSG } from './message.constant'

export class UserEmailNotFoundException extends NotFoundException {
  constructor() {
    super(EMAIL_NOT_EXIST_ERR_MSG)
  }
}
