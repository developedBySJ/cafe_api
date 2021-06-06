import { ConfigService } from '@nestjs/config'
import {
  DB_HOST,
  DB_DATABASE,
  DB_PASSWORD,
  DB_PORT,
  DB_USER,
} from '../common/constants/env.constant'
import { ConnectionOptions } from 'typeorm'

const configService = new ConfigService()

const config: ConnectionOptions = {
  type: 'postgres',
  host: configService.get(DB_HOST),
  port: +configService.get<number>(DB_PORT),
  username: configService.get(DB_USER),
  password: configService.get(DB_PASSWORD),
  database: configService.get(DB_DATABASE),
  entities: ['src/**/*{.entity,.index}{.ts,.js}'],
  migrations: ['src/migrations/*{.ts,.js}'],
  migrationsRun: true,
  synchronize: false,
  logging: true,
  cli: {
    migrationsDir: 'src/migrations',
  },
}

export = config
