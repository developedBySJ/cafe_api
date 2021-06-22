import { Module } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { DatabaseModule } from './database/database.module'
import { UsersModule } from './users/users.module'
import { AuthModule } from './auth/auth.module'
import * as Joi from '@hapi/joi'
import {
  JWT_SECRET,
  DB_DATABASE,
  DB_HOST,
  DB_PASSWORD,
  DB_PORT,
  DB_USER,
  PORT,
  JWT_EXP_TIME,
  MAIL_HOST,
  MAIL_PORT,
  MAIL_USER,
  MAIL_PASS,
} from './common'
import { MailModule } from './mail/mail.module'
import { MenusModule } from './menus/menus.module'
import { AssetsModule } from './assets/assets.module'
import { InventoryModule } from './inventory/inventory.module'
import { MenuItemsModule } from './menu-items/menu-items.module'
import { UserItemsModule } from './user-items/user-items.module'
import { ReviewsModule } from './reviews/reviews.module'
import { OrdersModule } from './orders/orders.module'
import { PaymentsModule } from './payments/payments.module';
@Module({
  imports: [
    ConfigModule.forRoot({
      validationSchema: Joi.object({
        [DB_HOST]: Joi.string().required(),
        [DB_PORT]: Joi.number().required(),
        [DB_USER]: Joi.string().required(),
        [DB_PASSWORD]: Joi.string().required(),
        [DB_DATABASE]: Joi.string().required(),
        [PORT]: Joi.number(),
        [JWT_SECRET]: Joi.string().required(),
        [JWT_EXP_TIME]: Joi.string().required(),
        [MAIL_HOST]: Joi.string().required(),
        [MAIL_PORT]: Joi.number().required(),
        [MAIL_USER]: Joi.string().required(),
        [MAIL_PASS]: Joi.string().required(),
      }),
    }),
    DatabaseModule,
    MailModule,
    UsersModule,
    AuthModule,
    MenusModule,
    AssetsModule,
    InventoryModule,
    MenuItemsModule,
    UserItemsModule,
    ReviewsModule,
    OrdersModule,
    PaymentsModule,
  ],
  controllers: [],
})
export class AppModule {}
