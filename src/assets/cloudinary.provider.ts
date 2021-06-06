import { Provider } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { v2 } from 'cloudinary'
import {
  CLOUDINARY_API_KEY,
  CLOUDINARY_API_SECRET,
  CLOUDINARY_CLOUD_NAME,
} from 'src/common'

export const CLOUDINARY = 'cloudinary'

export const CloudinaryProvider: Provider<any> = {
  provide: CLOUDINARY,
  useFactory: (configService: ConfigService): void => {
    return v2.config({
      cloud_name: configService.get(CLOUDINARY_CLOUD_NAME),
      api_key: configService.get(CLOUDINARY_API_KEY),
      api_secret: configService.get(CLOUDINARY_API_SECRET),
    })
  },
  inject: [ConfigService],
}
