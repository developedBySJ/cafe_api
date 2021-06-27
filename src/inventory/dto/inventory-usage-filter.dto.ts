import { IsOptional, IsUUID } from 'class-validator'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'

export class InventoryUsageFilterDto extends PageOptionsDto {
  @IsUUID()
  @IsOptional()
  readonly inventory?: string
}
