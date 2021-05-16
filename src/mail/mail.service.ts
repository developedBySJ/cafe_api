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
}
