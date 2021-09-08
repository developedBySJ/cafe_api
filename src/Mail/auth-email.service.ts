import { Injectable } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { Mailman, MailMessage } from '@squareboat/nest-mailman'

@Injectable()
export class AuthTemplate {
  frontendUrl: string
  static mailSender = Mailman.init()
  constructor() {
    this.frontendUrl = new ConfigService().get('FRONTEND_URL')
  }

  async welcome({ email, firstName }: { email: string; firstName: string }) {
    const mail = MailMessage.init()
      .subject('Welcome to Cuisine Restaurant')
      .greeting(`Hello ${firstName}`)
      .line('Thanks for registering on our site')
      .action('Explore Our Menus', `${this.frontendUrl}/menus`)

    await AuthTemplate.mailSender.to(email).send(mail)
  }

  async sendPasswordResetToken({
    token,
    email,
  }: {
    token: string
    email: string
  }) {
    const mail = MailMessage.init()
      .subject('Password Reset Token valid for 15 Min')
      .greeting(`Forgot Your Password?`)
      .line(
        `That's okay, it happens! Click on the button below to reset your password`,
      )
      .action(
        'Reset Your Password',
        `${this.frontendUrl}/reset-password/${token}`,
      )

    await AuthTemplate.mailSender.to(email).send(mail)
  }
  async sendPasswordResetSuccess({
    name,
    email,
  }: {
    name: string
    email: string
  }) {
    const mail = MailMessage.init()
      .subject('Password Reset Successful!')
      .greeting(`Hello ${name},`)
      .line(`Your password was updated!`)
      .line(
        `We'll always let you know when there is any activity on your account.`,
      )
      .line(`Click the login button to login with new password`)
      .action('Login', `${this.frontendUrl}/login`)

    await AuthTemplate.mailSender.to(email).send(mail)
  }
}
