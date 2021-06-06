import { IsEnum } from 'class-validator'
import { AssetType } from 'src/common'

export class AssetDto {
  @IsEnum(AssetType)
  type: AssetType
}
