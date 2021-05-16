import { Module } from '@nestjs/common'
import { PassportModule } from '@nestjs/passport'
import { UsersModule } from 'src/users/users.module'
import { AuthController } from './auth.controller'
import { AuthService } from './auth.service'
import { JwtModule } from '@nestjs/jwt'
import { ConfigModule, ConfigService } from '@nestjs/config'
import { JwtStrategy } from './strategy/jwt.strategy'
import { LocalStrategy } from './strategy/local.strategy'
import { TypeOrmModule } from '@nestjs/typeorm'
import { UserEntity } from 'src/users/entities/user.entity'
import { JWT_EXP_TIME, JWT_SECRET } from 'src/common'
import { MailerModule } from '@nestjs-modules/mailer'
import { MailService } from 'src/mail/mail.service'

@Module({
  imports: [
    MailerModule,
    UsersModule,
    PassportModule,
    ConfigModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (ConfigService: ConfigService) => ({
        secret: ConfigService.get(JWT_SECRET),
        signOptions: { expiresIn: ConfigService.get(JWT_EXP_TIME) },
      }),
    }),
    TypeOrmModule.forFeature([UserEntity]),
  ],
  controllers: [AuthController],
  providers: [AuthService, MailService, JwtStrategy, LocalStrategy],
  exports: [JwtModule],
})
export class AuthModule {}
