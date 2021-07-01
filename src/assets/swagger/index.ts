import { ApiProperty } from '@nestjs/swagger'

export class AssetResponse {
  @ApiProperty()
  id: string
  @ApiProperty()
  url: string
}
