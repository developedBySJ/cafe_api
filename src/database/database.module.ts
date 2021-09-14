import { Module } from '@nestjs/common'
import { ConfigModule, ConfigService } from '@nestjs/config'
import { TypeOrmModule } from '@nestjs/typeorm'
import {
  DATABASE_URL,
  DB_DATABASE,
  DB_HOST,
  DB_PASSWORD,
  DB_PORT,
  DB_USER,
} from 'src/common'
import { types } from 'pg'

types.setTypeParser(types.builtins.NUMERIC, (value: string): number =>
  parseFloat(value),
)
types.setTypeParser(types.builtins.INT8, (value) => parseInt(value))

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        url: configService.get<string>(DATABASE_URL),
        host: configService.get(DB_HOST),
        port: configService.get(DB_PORT),
        username: configService.get(DB_USER),
        password: configService.get(DB_PASSWORD),
        database: configService.get(DB_DATABASE),
        entities: ['dist/**/*.entity{.ts,.js}'],
        migrations: [__dirname + '/../migrations/*{.ts,.js}'],
        synchronize: process.env.NODE_ENV === 'development',
        ...(process.env.NODE_ENV !== 'development' && {
          ssl: true,
          extra: {
            ssl: {
              rejectUnauthorized: false,
            },
          },
        }),
        logging: 'all',
        logger: 'advanced-console',
        bigNumberStrings: false,
      }),
    }),
  ],
})
export class DatabaseModule {}
