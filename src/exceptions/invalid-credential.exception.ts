import { BadRequestException } from '@nestjs/common'
import { INVALID_EMAIL_OR_PASSWORD_MSG } from './message.constant'

export class InvalidCredentialsException extends BadRequestException {
  constructor(error?: string) {
    super(error || INVALID_EMAIL_OR_PASSWORD_MSG)
  }
}
