import { Injectable } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { Mailman, MailMessage } from '@squareboat/nest-mailman'
import { OrderEntity } from 'src/orders/entities/order.entity'

@Injectable()
export class OrdersEmailService {
  frontendUrl: string
  static mailSender = Mailman.init()
  constructor() {
    this.frontendUrl = new ConfigService().get('FRONTEND_URL')
  }

  async orderPlaced({
    email,
    firstName,
    orderId,
  }: {
    email: string
    firstName: string
    orderId: string
  }) {
    const mail = MailMessage.init()
      .subject('Order Placed Successfully!')
      .greeting(`Hello ${firstName}`)
      .line(`Your order #${orderId} has been placed successfully!`)
      .line('You can find invoice on our website')
      .line('Thank You!')
      .action('View Invoice', `${this.frontendUrl}/orders/${orderId}/invoice`)

    await OrdersEmailService.mailSender.to(email).send(mail)
  }

  async orderDelivered({ email, orderId }: { email: string; orderId: string }) {
    const mail = MailMessage.init()
      .subject('Order Delivered Successfully!')
      .line(`Order #${orderId} is delivered successfully!`)
      .line('Thank You for ordering from Cuisine restaurant!')
      .action('Explore Dishes', `${this.frontendUrl}/dishes`)

    await OrdersEmailService.mailSender.to(email).send(mail)
  }
}
