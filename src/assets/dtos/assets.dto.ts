import { ApiProperty } from '@nestjs/swagger'
import { IsEnum } from 'class-validator'
import { AssetType } from 'src/common'

export class AssetDto {
  @ApiProperty({ enum: AssetType })
  @IsEnum(AssetType)
  type: AssetType
}
