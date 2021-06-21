import { BadRequestException } from '@nestjs/common'
import { REVIEW_EXIST_ERR_MSG } from './message.constant'

export class ReviewExistException extends BadRequestException {
  constructor(error?: string) {
    super(error || REVIEW_EXIST_ERR_MSG)
  }
}
