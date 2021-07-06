import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseUUIDPipe,
  UseGuards,
  Query,
} from '@nestjs/common'
import { UsersService } from './users.service'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'
import { ApiTags } from '@nestjs/swagger'
import { JwtAuthGuard } from 'src/auth/guards'
import { Roles } from 'src/common/decorators'
import { UserRole } from 'src/common'
import { RolesGuard } from 'src/common/guards/roles.guards'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from './entities/user.entity'
import { UserFilterDto } from './dto/user-filter.dto'
import { JwtRefreshGuard } from 'src/auth/guards/refresh.guard'

@ApiTags('Users')
@Controller('users')
export class UsersController {
  constructor(private readonly _usersService: UsersService) {}

  @Post()
  @Roles(UserRole.Admin)
  @UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
  create(@User() curUser: UserEntity, @Body() createUserDto: CreateUserDto) {
    return this._usersService.create(createUserDto, curUser)
  }

  @Get()
  @Roles(UserRole.Admin, UserRole.Manager)
  @UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
  findAll(@Query() pageOption: UserFilterDto) {
    return this._usersService.findAll(pageOption)
  }

  @Get(':id')
  @Roles(UserRole.Admin, UserRole.Manager)
  @UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this._usersService.findOne(id)
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, JwtRefreshGuard)
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateUserDto: UpdateUserDto,
    @User() curUser: UserEntity,
  ) {
    return this._usersService.update(id, updateUserDto, curUser)
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, JwtRefreshGuard)
  remove(@Param('id', ParseUUIDPipe) id: string, @User() curUser: UserEntity) {
    return this._usersService.remove(id, curUser)
  }
}
