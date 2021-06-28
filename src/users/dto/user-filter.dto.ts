import { IsEnum, IsOptional, IsString } from 'class-validator'
import { UserRole } from 'src/common'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'

export enum UserSortBy {
  DateOfBirth = 'dateOfBirth',
  FirstName = 'firstName',
  Email = 'email',
  Role = 'role',
  CreatedAt = 'createdAt',
}

export class UserFilterDto extends PageOptionsDto {
  @IsString()
  @IsOptional()
  search?: string

  @IsEnum(UserRole)
  @IsOptional()
  role?: UserRole

  @IsEnum(UserSortBy)
  @IsOptional()
  sortBy?: UserSortBy
}
