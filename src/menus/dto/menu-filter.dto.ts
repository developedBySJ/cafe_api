import { Transform } from 'class-transformer'
import { IsBoolean, IsOptional, IsString } from 'class-validator'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'

export class MenuFilterDto extends PageOptionsDto {
  @IsString()
  @IsOptional()
  search?: string

  @IsBoolean()
  @Transform(({ value }) => ['1', 1, 'true', true].includes(value))
  @IsOptional()
  isActive?: boolean
}
