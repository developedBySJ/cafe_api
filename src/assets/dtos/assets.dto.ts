import { ApiProperty } from '@nestjs/swagger'
import { IsEnum, IsOptional } from 'class-validator'
import { AssetType } from 'src/common'

export class AssetDto {
  @ApiProperty({ enum: AssetType })
  @IsEnum(AssetType)
  @IsOptional()
  type: AssetType = AssetType.Other
}
