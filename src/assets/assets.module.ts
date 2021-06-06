import { Module } from '@nestjs/common'
import { AssetsService } from './assets.service'
import { AssetsController } from './assets.controller'
import { CloudinaryService } from './cloudinary.service'
import { ConfigModule } from '@nestjs/config'
import { CloudinaryProvider } from './cloudinary.provider'
import { TypeOrmModule } from '@nestjs/typeorm'
import { AssetEntity } from './entities/assets.entity'

@Module({
  imports: [ConfigModule, TypeOrmModule.forFeature([AssetEntity])],
  providers: [AssetsService, CloudinaryProvider, CloudinaryService],
  controllers: [AssetsController],
})
export class AssetsModule {}
