import { BadRequestException } from '@nestjs/common'
import { INSUFFICIENT_STOCKS_ERR_MSG } from './message.constant'

export class InSufficientStocksException extends BadRequestException {
  constructor(error?: string) {
    super(error || INSUFFICIENT_STOCKS_ERR_MSG)
  }
}
