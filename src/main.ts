import { ValidationPipe } from '@nestjs/common'
import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'
import { setUpSwagger } from './utils'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  app.setGlobalPrefix('/api/v1')
  app.useGlobalPipes(new ValidationPipe({ transform: true }))

  setUpSwagger(app)

  await app.listen(9000)
}
bootstrap()
