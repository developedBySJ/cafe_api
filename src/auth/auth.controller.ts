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
} from '@nestjs/common'
import { Response, Request } from 'express'
import { CreateUserDto } from 'src/users/dto/create-user.dto'
import { AuthService } from './auth.service'
import { LocalAuthGuard } from './guards'

@Controller('/')
export class AuthController {
  constructor(private readonly _authService: AuthService) {}
  @HttpCode(HttpStatus.NO_CONTENT)
  @Post('/logout')
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
}
