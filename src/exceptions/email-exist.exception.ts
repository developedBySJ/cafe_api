import { BadRequestException } from '@nestjs/common'
import { EMAIL_EXIST_ERR_MSG } from './message.constant'

export class EmailAddressExistException extends BadRequestException {
  constructor(error?: string) {
    super(error || EMAIL_EXIST_ERR_MSG)
  }
}
