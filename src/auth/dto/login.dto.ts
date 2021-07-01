import { ApiProperty } from '@nestjs/swagger'
import { IsEmail, IsString, Length } from 'class-validator'

export class LoginDto {
  @ApiProperty()
  @IsEmail()
  @Length(3, 100)
  email: string

  @ApiProperty()
  @IsString()
  @Length(6, 16)
  password: string
}
