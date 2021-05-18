import {
  Controller,
  Get,
  Post,
  Body,
  Req,
  Res,
  UseGuards,
  HttpStatus,
  HttpCode,
  Patch,
  Param,
} from '@nestjs/common'
import { Response, Request } from 'express'
import { CreateUserDto } from 'src/users/dto/create-user.dto'
import { AuthService } from './auth.service'
import { ForgotPasswordDto } from './dto/forgot-password.dto'
import { ResetPassword } from './dto/reset-password.dto'
import { LocalAuthGuard } from './guards'

@Controller('/')
export class AuthController {
  constructor(private readonly _authService: AuthService) {}
  @HttpCode(HttpStatus.NO_CONTENT)
  @Patch('/logout')
  logout(@Req() req: Request, @Res({ passthrough: true }) res: Response) {
    return this._authService.logout(req, res)
  }
  @UseGuards(LocalAuthGuard)
  @Post('/login')
  logIn(@Req() req: Request, @Res({ passthrough: true }) res: Response) {
    return this._authService.login(req, res)
  }

  @Post('/signup')
  signUp(@Body() user: CreateUserDto) {
    return this._authService.signUp(user)
  }

  @Get('/whoAmI')
  whoAmI(@Req() req: Request) {
    return this._authService.whoAmI(req)
  }

  @HttpCode(HttpStatus.NO_CONTENT)
  @Post('/forgot-password')
  forgotPassword(@Req() req: Request, @Body() { email }: ForgotPasswordDto) {
    return this._authService.forgotPassword(req, email)
  }

  @HttpCode(HttpStatus.NO_CONTENT)
  @Patch('/reset-password/:token')
  resetPassword(
    @Param('token') param: string,
    @Body() { password }: ResetPassword,
  ) {
    return this._authService.resetPassword(param, password)
  }
}
