import {
  ForbiddenException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { plainToClass } from 'class-transformer'
import { UserRole } from 'src/common'
import { EmailAddressExistException } from 'src/exceptions'
import { EMAIL_EXIST_ERR_MSG } from 'src/exceptions/message.constant'
import { UserNotFoundException } from 'src/exceptions/user-not-found.exception'
import { UtilsService } from 'src/utils/services'
import { Repository } from 'typeorm'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'
import { UserFilterDto } from './dto/user-filter.dto'
import { UserEntity } from './entities/user.entity'

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UserEntity)
    private _usersRepository: Repository<UserEntity>,
  ) {}

  private async verify(id: string, curUser: UserEntity) {
    const user = await this.findOne(id)
    const access = [UserRole.Admin, UserRole.Manager]
    if (
      !UtilsService.hasAbility({
        doc: user,
        ownerKey: 'id',
        user: curUser,
        access,
      })
    )
      throw new ForbiddenException()

    return user
  }

  async create(userData: CreateUserDto, curUser?: UserEntity) {
    const password = await UtilsService.hashPassword(userData.password)
    const userRole = curUser?.role === UserRole.Admin ? curUser.role : undefined

    const newUser = this._usersRepository.create({
      ...userData,
      password,
      role: userRole,
    })

    try {
      await this._usersRepository.save(newUser)
      return this.findOne(newUser.id)
    } catch (error) {
      if (error?.code === '23505') {
        throw new EmailAddressExistException(EMAIL_EXIST_ERR_MSG)
      }
      throw new InternalServerErrorException()
    }
  }

  async findAll({ skip, limit, sort, search, role, sortBy }: UserFilterDto) {
    const users = await this._usersRepository.findAndCount({
      skip,
      take: limit,
      ...(sortBy && { order: { [sortBy]: sort } }),
      where: { ...(role && { role }) },
    })

    return users
  }

  async findOne(id: string) {
    const user = await this._usersRepository.findOne({ id })
    if (!user) throw new UserNotFoundException(id)
    return user
  }

  async findByEmail(email: string) {
    const user = await this._usersRepository.findOne({ email })
    if (!user) throw new NotFoundException()
    return user
  }

  async update(id: string, updateUserDto: UpdateUserDto, curUser: UserEntity) {
    const user = await this.verify(id, curUser)

    const updatedUser = await this._usersRepository.save(
      Object.assign(user, updateUserDto),
    )
    return plainToClass(UserEntity, updatedUser)
  }

  async remove(id: string, curUser: UserEntity) {
    const user = await this.verify(id, curUser)
    await this._usersRepository.delete(user)
    return null
  }
}
