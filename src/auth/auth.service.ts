import { Injectable, InternalServerErrorException } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { JwtService } from '@nestjs/jwt'
import { InjectRepository } from '@nestjs/typeorm'
import {
  AUTH_COOKIE_KEY,
  JWTPayload,
  JWT_REFRESH_TOKEN_EXP_TIME,
  JWT_REFRESH_TOKEN_SECRET,
  RefreshTokenPayload,
  REFRESH_TOKEN_COOKIE_KEY,
} from 'src/common'
import { CreateUserDto } from 'src/users/dto/create-user.dto'
import { UserEntity } from 'src/users/entities/user.entity'
import { UsersService } from 'src/users/users.service'
import { UtilsService } from 'src/utils/services'
import { Connection, Repository } from 'typeorm'
import { Request, Response } from 'express'
import * as moment from 'moment'
import { MailService } from 'src/mail/mail.service'
import { randomBytes } from 'crypto'
import { InvalidCredentialsException } from 'src/exceptions/invalid-credential.exception'
import { ResetTokenExpireException } from 'src/exceptions/token-exp.exception'
import { plainToClass } from 'class-transformer'

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly _usersRepository: Repository<UserEntity>,
    private readonly _userService: UsersService,
    private readonly _jwtService: JwtService,
    private readonly _configService: ConfigService,
    private readonly _mailService: MailService,
    private readonly _connection: Connection,
  ) {}

  getAccessToken(payload: JWTPayload) {
    return this._jwtService.sign(payload)
  }

  private _getRefreshToken(userId: string) {
    const payload: RefreshTokenPayload = { userId }
    const token = this._jwtService.sign(payload, {
      secret: this._configService.get(JWT_REFRESH_TOKEN_SECRET),
      expiresIn: `${this._configService.get(JWT_REFRESH_TOKEN_EXP_TIME)}s`,
    })
    return token
  }

  async logout(req: Request, res: Response) {
    const user = req.user as UserEntity
    res.clearCookie(AUTH_COOKIE_KEY)
    res.clearCookie(REFRESH_TOKEN_COOKIE_KEY)
    user?.id &&
      (await this._usersRepository.update(user.id, {
        currentHashedRefreshToken: null,
      }))
    return
  }

  async _setRefreshTokenCookie(res: Response, userId: string): Promise<string> {
    const refreshToken = this._getRefreshToken(userId)
    res.cookie(REFRESH_TOKEN_COOKIE_KEY, refreshToken, {
      maxAge: this._configService.get(JWT_REFRESH_TOKEN_EXP_TIME) * 1000,
      httpOnly: true,
      sameSite: true,
    })
    const currentHashedRefreshToken = await UtilsService.hashPassword(
      refreshToken,
    )
    await this._usersRepository.update(userId, {
      currentHashedRefreshToken,
    })
    return refreshToken
  }

  _setAccessCookie(res: Response, { email, role, id: userId }: UserEntity) {
    const token = this.getAccessToken({ email, role, userId })

    res.cookie(AUTH_COOKIE_KEY, token, {
      maxAge: 2 * 24 * 3600 * 1000,
      httpOnly: true,
      sameSite: true,
    })
  }

  async login(req: Request, res: Response) {
    const user = req.user as UserEntity

    await this._setRefreshTokenCookie(res, user.id)
    this._setAccessCookie(res, user)

    return plainToClass(UserEntity, user)
  }

  signUp(user: CreateUserDto) {
    return this._userService.create(user)
  }

  async whoAmI(req: Request) {
    const viewerCookie = req.cookies[AUTH_COOKIE_KEY]

    if (!viewerCookie) {
      return null
    }

    const viewer = this._jwtService.verify<JWTPayload>(viewerCookie)

    if (viewer.userId) {
      const user = await this._userService.findOne(viewer.userId)
      return user
    }
    return null
  }

  async validateUser(email: string, password: string) {
    const user = await this._usersRepository.findOne({ email })

    if (!user) throw new InvalidCredentialsException()

    const isValidUser = await UtilsService.comparePassword(
      password,
      user.password,
    )

    if (!isValidUser) throw new InvalidCredentialsException()

    return user
  }

  async validateRefreshToken(refreshToken: string, userId: string) {
    const user = await this._userService.findOne(userId)

    const isRefreshTokenValid = await UtilsService.comparePassword(
      refreshToken,
      user.currentHashedRefreshToken,
    )
    if (!isRefreshTokenValid) return null

    return user
  }

  async forgotPassword(req: Request, email: string): Promise<null> {
    const user = await this._userService.findByEmail(email)
    const queryRunner = this._connection.createQueryRunner()

    await queryRunner.connect()
    await queryRunner.startTransaction()

    const resetToken = randomBytes(64).toString('hex')
    const resetUrl = `${req.headers.host}/api/v1/password-reset/${resetToken}`
    try {
      user.passwordResetToken = resetToken
      user.passwordResetRequestAt = new Date()

      await this._mailService.passwordReset(resetUrl, user.email)
      await queryRunner.manager.save(user)

      await queryRunner.commitTransaction()
      return null
    } catch (error) {
      // console.log(error)
      await queryRunner.rollbackTransaction()
      throw new InternalServerErrorException()
    } finally {
      await queryRunner.release()
    }
  }

  async resetPassword(token: string, password: string): Promise<null> {
    const user = await this._usersRepository.findOne({
      passwordResetToken: token,
    })

    if (!user) throw new ResetTokenExpireException()

    if (
      user.passwordResetRequestAt &&
      moment(user.passwordResetRequestAt).add(1, 'minutes').isAfter(new Date())
    ) {
      const queryRunner = this._connection.createQueryRunner()

      await queryRunner.connect()
      await queryRunner.startTransaction()
      try {
        user.password = await UtilsService.hashPassword(password)
        user.passwordResetRequestAt = null
        user.passwordResetToken = null
        user.passwordResetAt = new Date()

        await queryRunner.manager.save(user)

        await queryRunner.commitTransaction()
        return null
      } catch (error) {
        // console.log(error)
        await queryRunner.rollbackTransaction()
        throw new InternalServerErrorException()
      } finally {
        await queryRunner.release()
      }
    } else {
      user.passwordResetRequestAt = null
      user.passwordResetToken = null
      await this._usersRepository.save(user)
      throw new ResetTokenExpireException()
    }
  }
}
