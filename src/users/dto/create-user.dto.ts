import {
  IsDate,
  IsEmail,
  IsEnum,
  IsOptional,
  IsString,
  Length,
  MinDate,
} from 'class-validator'
import { UserRole } from '../entities/user.entity'
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
  email: string

  @IsString()
  @Length(6, 16)
  password: string

  @MinDate(new Date())
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
