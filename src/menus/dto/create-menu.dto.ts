import { Type } from 'class-transformer'
import { IsBoolean, IsOptional, IsString, Length } from 'class-validator'

export class CreateMenuDto {
  @IsString()
  @Length(3, 50)
  name: string

  @IsBoolean()
  @IsOptional()
  isActive?: boolean

  @IsString()
  @IsOptional()
  image?: string
}
