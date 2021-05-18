import { Module } from '@nestjs/common'
import { ConfigModule, ConfigService } from '@nestjs/config'
import { TypeOrmModule } from '@nestjs/typeorm'
import { DB_DATABASE, DB_HOST, DB_PASSWORD, DB_PORT, DB_USER } from 'src/common'

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get(DB_HOST),
        port: configService.get(DB_PORT),
        username: configService.get(DB_USER),
        password: configService.get(DB_PASSWORD),
        database: configService.get(DB_DATABASE),
        entities: ['dist/**/*.entity{.ts,.js}'],
        migrations: [__dirname + '/../migrations/*{.ts,.js}'],
        synchronize: true,
        logging: 'all',
        logger: 'advanced-console',
      }),
    }),
  ],
})
export class DatabaseModule {}
