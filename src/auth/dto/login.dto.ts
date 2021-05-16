import { IsEmail, IsString, Length } from 'class-validator'

export class LoginDto {
  @IsEmail()
  @Length(3, 100)
  email: string

  @IsString()
  @Length(6, 16)
  password: string
}
