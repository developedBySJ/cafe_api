import { ClassSerializerInterceptor, ValidationPipe } from '@nestjs/common'
import { NestFactory, Reflector } from '@nestjs/core'
import * as cookieParser from 'cookie-parser'
import * as helmet from 'helmet'
import sslRedirect from 'heroku-ssl-redirect'
import { AppModule } from './app.module'
import { setUpSwagger } from './utils'

console.log(process.env)
async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  app.use(helmet({ contentSecurityPolicy: false }))
  app.use(sslRedirect())
  app.enableCors()
  app.use(cookieParser())
  app.setGlobalPrefix('/api/v1')

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      transformOptions: { enableImplicitConversion: true },
      whitelist: true,
    }),
  )

  app.useGlobalInterceptors(new ClassSerializerInterceptor(app.get(Reflector)))
  setUpSwagger(app)

  await app.listen(process.env.PORT || 9000)
}
bootstrap()
