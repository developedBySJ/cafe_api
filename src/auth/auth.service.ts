import { BadRequestException, Injectable, UseGuards } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { JwtService } from '@nestjs/jwt'
import { InjectRepository } from '@nestjs/typeorm'
import { JWTPayload, JWT_EXP_TIME } from 'src/common'
import { INVALID_EMAIL_OR_PASSWORD } from 'src/exceptions/message.constant'
import { CreateUserDto } from 'src/users/dto/create-user.dto'
import { UserEntity } from 'src/users/entities/user.entity'
import { UsersService } from 'src/users/users.service'
import { UtilsService } from 'src/utils/services'
import { Repository } from 'typeorm'
import { Request, Response } from 'express'
import { LoginDto } from './dto/login.dto'
import { LocalAuthGuard } from './guards'
import { MailService } from 'src/mail/mail.service'

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly _usersRepository: Repository<UserEntity>,
    private readonly _userService: UsersService,
    private readonly _jwtService: JwtService,
    private readonly _configService: ConfigService,
    private readonly _mailService: MailService,
  ) {}

  signToken(payload: JWTPayload) {
    return this._jwtService.sign(payload)
  }

  logout(req: Request, res: Response) {
    res.clearCookie('__auth')
  }

  async login(req: Request, res: Response) {
    const { email, role, id: userId } = req.user as UserEntity
    const token = this.signToken({ email, role, userId })
    res.cookie('__auth', token, {
      maxAge: 2 * 24 * 3600 * 1000,
      httpOnly: true,
    })
    await this._mailService.sendWelcome()
    return req.user
  }

  signUp(user: CreateUserDto) {
    return this._userService.create(user)
  }

  async whoAmI(req: Request) {
    const userId = (req.user as any)?.id
    if (userId) {
      const user = await this._usersRepository.findOne({ id: userId })
      return { ...user, didRequest: true }
    }
    return { didRequest: true }
  }

  async validateUser(email: string, password: string) {
    const user = await this._usersRepository
      .createQueryBuilder()
      .where({ email })
      .addSelect('*')
      .getOne()
    if (!user) throw new BadRequestException(INVALID_EMAIL_OR_PASSWORD)

    const isValidUser = await UtilsService.comparePassword(
      password,
      user.password,
    )

    if (!isValidUser) throw new BadRequestException(INVALID_EMAIL_OR_PASSWORD)
    return user
  }
}
