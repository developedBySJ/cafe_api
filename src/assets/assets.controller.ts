import {
  Body,
  Controller,
  Delete,
  ForbiddenException,
  HttpCode,
  HttpStatus,
  Post,
  UploadedFile,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common'
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express'
import { JwtAuthGuard } from 'src/auth/guards'
import { AssetType, UserRole } from 'src/common'
import { Roles } from 'src/common/decorators'
import { User } from 'src/common/decorators/user.decorator'
import { RolesGuard } from 'src/common/guards/roles.guards'
import { JwtRefreshGuard } from 'src/auth/guards/refresh.guard'
import { UserEntity } from 'src/users/entities/user.entity'
import { AssetsService } from './assets.service'
import { AssetDto } from './dtos/assets.dto'

@Controller()
export class AssetsController {
  constructor(private readonly _assetService: AssetsService) {}

  private assetAccess = {
    [UserRole.Admin]: Object.values(AssetType),
    [UserRole.Customer]: [AssetType.Avatar, AssetType.Review],
  }

  @Post('/asset')
  @HttpCode(HttpStatus.OK)
  @UseInterceptors(FileInterceptor('file'))
  @UseGuards(JwtAuthGuard, JwtRefreshGuard)
  uploadSingle(
    @UploadedFile() file: Express.Multer.File,
    @Body() metaData: AssetDto,
    @User() curUser: UserEntity,
  ) {
    if (!this.assetAccess[curUser.role].includes(metaData.type)) {
      throw new ForbiddenException()
    }
    return this._assetService.uploadSingle(file, curUser, metaData.type)
  }

  @Post('/assets')
  @HttpCode(HttpStatus.OK)
  @UseInterceptors(FilesInterceptor('files', 5))
  @UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  uploadMulti(
    @UploadedFiles() files: Express.Multer.File[],
    @Body() metaData: AssetDto,
    @User() curUser: UserEntity,
  ) {
    if (!this.assetAccess[curUser.role].includes(metaData.type)) {
      throw new ForbiddenException()
    }
    return this._assetService.uploadMulti(files, curUser, metaData.type)
  }

  @Delete()
  delete() {
    return this._assetService.delete()
  }
}
