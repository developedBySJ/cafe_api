import { IsOptional, IsString } from 'class-validator'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'

export class InventoryFilterDto extends PageOptionsDto {
  @IsString({ each: true })
  @IsOptional()
  readonly tags?: string[]
}
