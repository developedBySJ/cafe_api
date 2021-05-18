import { MailerService } from '@nestjs-modules/mailer'
import { Injectable } from '@nestjs/common'

@Injectable()
export class MailService {
  constructor(private readonly _mailerService: MailerService) {}

  async sendWelcome() {
    try {
      await this._mailerService.sendMail({
        to: 'admin@admin.com',
        subject: 'Welcome',
        template: './templates/welcome',
        context: {},
      })
    } catch (error) {
      console.log(error)
    }
  }
  async passwordReset(resetUrl: string, email: string, text?: string) {
    await this._mailerService.sendMail({
      to: email,
      subject: 'Password reset token',
      template: './templates/passwordReset',
      text,
      context: {
        url: resetUrl,
      },
    })
  }
}
