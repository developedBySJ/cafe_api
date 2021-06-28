import { ExtractJwt, Strategy } from 'passport-jwt'
import { PassportStrategy } from '@nestjs/passport'
import { Injectable } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { Request } from 'express'
import {
  JWT_REFRESH_TOKEN_SECRET,
  RefreshTokenPayload,
  REFRESH_TOKEN_COOKIE_KEY,
} from 'src/common'
import { AuthService } from '../auth.service'

@Injectable()
export class JwtRefreshTokenStrategy extends PassportStrategy(
  Strategy,
  'jwt-refresh-token',
) {
  constructor(
    private readonly _configService: ConfigService,
    private readonly _authService: AuthService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromExtractors([
        (request: Request) => {
          return request?.cookies?.[REFRESH_TOKEN_COOKIE_KEY]
        },
      ]),
      secretOrKey: _configService.get(JWT_REFRESH_TOKEN_SECRET),
      passReqToCallback: true,
    })
  }

  async validate(request: Request, payload: RefreshTokenPayload) {
    const refreshToken = request?.cookies?.[REFRESH_TOKEN_COOKIE_KEY]
    return this._authService.validateRefreshToken(refreshToken, payload.userId)
  }
}
