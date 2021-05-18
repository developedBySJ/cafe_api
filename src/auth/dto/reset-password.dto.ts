import { IsString, Length } from 'class-validator'

export class ResetPassword {
  @IsString()
  @Length(6, 16)
  password: string
}
