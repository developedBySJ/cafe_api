import { Transform } from 'class-transformer'
import {
  IsDate,
  IsEmail,
  IsEnum,
  IsOptional,
  IsString,
  Length,
  MaxDate,
} from 'class-validator'
import { UserRole } from 'src/common'
export class CreateUserDto {
  @Length(3, 64)
  @IsString()
  firstName: string

  @Length(3, 64)
  @IsString()
  @IsOptional()
  lastName?: string

  @IsEmail()
  @Length(3, 100)
  @Transform((email) => String(email.value).toLowerCase())
  email: string

  @IsString()
  @Length(6, 16)
  password: string

  @MaxDate(new Date())
  @IsDate()
  @IsOptional()
  dateOfBirth?: Date

  @IsString()
  @IsEnum(UserRole)
  @IsOptional()
  role?: UserRole

  @IsString()
  @IsOptional()
  address?: string

  @Length(3, 512)
  @IsString()
  @IsOptional()
  avatar?: string
}
