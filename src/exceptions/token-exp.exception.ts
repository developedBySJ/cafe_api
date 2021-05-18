import { BadRequestException } from '@nestjs/common'
import { RESET_TOKEN_EXP_MSG } from './message.constant'

export class ResetTokenExpireException extends BadRequestException {
  constructor(error?: string) {
    super(error || RESET_TOKEN_EXP_MSG)
  }
}
