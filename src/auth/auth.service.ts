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
import { randomBytes } from 'crypto'
import { InvalidCredentialsException } from 'src/exceptions/invalid-credential.exception'
import { ResetTokenExpireException } from 'src/exceptions/token-exp.exception'
import { plainToClass } from 'class-transformer'
import { AuthTemplate } from 'src/Mail/auth-email.service'

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly _usersRepository: Repository<UserEntity>,
    private readonly _userService: UsersService,
    private readonly _jwtService: JwtService,
    private readonly _configService: ConfigService,
    private readonly _connection: Connection,
    private readonly _authEmailService: AuthTemplate,
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
    const user = await this._userService.findOne((req.user as UserEntity)?.id)

    await this._setRefreshTokenCookie(res, user.id)
    this._setAccessCookie(res, user)

    return plainToClass(UserEntity, user)
  }

  async signUp(user: CreateUserDto) {
    const newUser = await this._userService.create(user)

    await this._authEmailService.welcome({
      email: newUser.email,
      firstName: newUser.firstName,
    })

    return newUser
  }

  async whoAmI(req: Request, res: Response) {
    const viewerCookie = req.cookies[AUTH_COOKIE_KEY]

    if (!viewerCookie) {
      return this.logout(req, res)
    }

    const viewer = this._jwtService.verify<JWTPayload>(viewerCookie)

    if (viewer.userId) {
      try {
        const user = await this._usersRepository.findOne(viewer.userId)
        if (!user) return this.logout(req, res)
        return user
      } catch (error) {
        return this.logout(req, res)
      }
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

    try {
      user.passwordResetToken = resetToken
      user.passwordResetRequestAt = new Date()

      await this._authEmailService.sendPasswordResetToken({
        email: user.email,
        token: resetToken,
      })
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

        await this._authEmailService.sendPasswordResetSuccess({
          email: user.email,
          name: user.firstName,
        })

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
