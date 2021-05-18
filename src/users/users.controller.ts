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
  Req,
} from '@nestjs/common'
import { UsersService } from './users.service'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'
import { ApiTags } from '@nestjs/swagger'
import { JwtAuthGuard } from 'src/auth/guards'
import { Roles } from 'src/common/decorators'
import { UserRole } from 'src/common'
import { RolesGuard } from 'src/common/guards/roles.guards'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from './entities/user.entity'

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly _usersService: UsersService) {}

  @Post()
  @Roles(UserRole.Admin)
  @UseGuards(JwtAuthGuard, RolesGuard)
  create(@User() curUser: UserEntity, @Body() createUserDto: CreateUserDto) {
    return this._usersService.create(createUserDto, curUser)
  }

  @Get()
  @Roles(UserRole.Admin)
  @UseGuards(JwtAuthGuard, RolesGuard)
  findAll(@Query() pageOption: PageOptionsDto) {
    return this._usersService.findAll(pageOption)
  }

  @Get(':id')
  @Roles(UserRole.Admin, UserRole.Customer)
  @UseGuards(JwtAuthGuard, RolesGuard)
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this._usersService.findOne(id)
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateUserDto: UpdateUserDto,
    @User() curUser: UserEntity,
  ) {
    return this._usersService.update(id, updateUserDto, curUser)
  }

  @Delete(':id')
  @Roles(UserRole.Admin)
  @UseGuards(JwtAuthGuard, RolesGuard)
  remove(@Param('id', ParseUUIDPipe) id: string) {
    return this._usersService.remove(id)
  }
}
