import { Injectable } from '@nestjs/common'
import * as cloudinary from 'cloudinary'
import { randomBytes } from 'crypto'
import { Readable } from 'stream'
import slugify from 'slugify'

@Injectable()
export class CloudinaryService {
  private bufferToStream(binary: Buffer) {
    const readableInstanceStream = new Readable({
      read() {
        this.push(binary)
        this.push(null)
      },
    })

    return readableInstanceStream
  }
  async upload(
    req: Express.Multer.File,
    folder = '/',
  ): Promise<cloudinary.UploadApiResponse> {
    const [reqFileName, _] = req.originalname.split('.')

    const fileName = `${slugify(reqFileName, {
      remove: /[*+~.()'"!:@]/g,
    })}-${randomBytes(4).toString('hex')}`

    return new Promise((resolve, reject) => {
      const uploadStream = cloudinary.v2.uploader.upload_stream(
        {
          folder: `${folder}`,
          public_id: fileName,
          unique_filename: true,
        },
        (err, img) => {
          if (img) {
            resolve(img)
          } else {
            reject(err)
          }
        },
      )

      this.bufferToStream(req.buffer).pipe(uploadStream)
    })
  }
}
