import { Injectable, InternalServerErrorException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { AssetType, CLOUDINARY_FOLDER } from 'src/common'
import { AssetUploadFailedException } from 'src/exceptions'
import { UserEntity } from 'src/users/entities/user.entity'
import { Repository } from 'typeorm'
import { CloudinaryService } from './cloudinary.service'
import { AssetEntity } from './entities/assets.entity'

@Injectable()
export class AssetsService {
  constructor(
    private readonly _cloudinaryService: CloudinaryService,
    @InjectRepository(AssetEntity)
    private readonly _assetRepository: Repository<AssetEntity>,
  ) {}

  async uploadSingle(
    file: Express.Multer.File,
    curUser: UserEntity,
    type: AssetType,
  ) {
    try {
      const res = await this._cloudinaryService.upload(
        file,
        `${CLOUDINARY_FOLDER}/${type}`,
      )
      const _newAsset = this._assetRepository.create({
        format: res.format,
        publicId: res.public_id,
        url: res.secure_url,
        type,
        createdBy: curUser,
      })

      const newAsset = await this._assetRepository.save(_newAsset)

      return {
        id: newAsset.id,
        url: res.secure_url,
      }
    } catch (error) {
      throw new AssetUploadFailedException()
    }
  }
  async uploadMulti(
    files: Express.Multer.File[],
    curUser: UserEntity,
    type: AssetType,
  ) {
    try {
      const res = await Promise.all(
        files.map((file) =>
          this._cloudinaryService.upload(file, `${CLOUDINARY_FOLDER}/${type}`),
        ),
      )
      const assetMap = res.map((file) => ({
        format: file.format,
        publicId: file.public_id,
        url: file.secure_url,
        type,
        createdBy: curUser,
      }))

      const _newAssets = this._assetRepository.create(assetMap)
      const newAsset = await this._assetRepository.save(_newAssets)

      return newAsset.map((asset) => ({ id: asset.id, url: asset.url }))
    } catch (error) {
      throw new AssetUploadFailedException()
    }
  }
  delete() {
    return
  }
}
