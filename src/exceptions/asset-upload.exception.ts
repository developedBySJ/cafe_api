import { InternalServerErrorException } from '@nestjs/common'
import { IMAGE_UPLOAD_ERR_MSG } from './message.constant'

export class AssetUploadFailedException extends InternalServerErrorException {
  constructor(error?: string) {
    super(error || IMAGE_UPLOAD_ERR_MSG)
  }
}
