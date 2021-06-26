import { IsOptional, IsString } from 'class-validator'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'

export class InventoryFilterDto extends PageOptionsDto {
  @IsString()
  @IsOptional()
  readonly tags?: string
}
