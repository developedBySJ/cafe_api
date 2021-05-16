import { MailerModule } from '@nestjs-modules/mailer'
import { Module } from '@nestjs/common'
import { join } from 'path'
import { MailService } from './mail.service'
import { EjsAdapter } from '@nestjs-modules/mailer/dist/adapters/ejs.adapter'
import { ConfigModule, ConfigService } from '@nestjs/config'
import { MAIL_HOST, MAIL_PASS, MAIL_PORT, MAIL_USER } from 'src/common'

@Module({
  imports: [
    MailerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        transport: {
          host: configService.get(MAIL_HOST),
          port: configService.get(MAIL_PORT),
          auth: {
            user: configService.get(MAIL_USER),
            pass: configService.get(MAIL_PASS),
          },
        },
        defaults: {
          from: '"No Reply" <noreply@example.com>',
        },
        template: {
          dir: join(__dirname, 'templates'),
          adapter: new EjsAdapter(), // or new PugAdapter() or new EjsAdapter()
          options: {
            strict: true,
          },
        },
      }),
    }),
  ],
  providers: [MailService],
  exports: [MailService],
})
export class MailModule {}
