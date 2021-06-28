import { ExtractJwt, Strategy } from 'passport-jwt'
import { PassportStrategy } from '@nestjs/passport'
import { Inject, Injectable } from '@nestjs/common'
import { Request } from 'express'
import { ConfigService } from '@nestjs/config'
import { AUTH_COOKIE_KEY, JWTPayload, JWT_SECRET } from 'src/common/'
import { UsersService } from 'src/users/users.service'

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly _userService: UsersService) {
    super({
      jwtFromRequest: ExtractJwt.fromExtractors([
        (request: Request) => request?.cookies?.[AUTH_COOKIE_KEY],
        ExtractJwt.fromAuthHeaderAsBearerToken(),
      ]),
      ignoreExpiration: false,
      secretOrKey: new ConfigService().get(JWT_SECRET),
    })
  }

  async validate(payload: JWTPayload) {
    const user = await this._userService.findOne(payload.userId)
    return user
  }
}
