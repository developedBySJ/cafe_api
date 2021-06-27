import {
  ForbiddenException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { plainToClass } from 'class-transformer'
import { UserRole } from 'src/common'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'
import { EmailAddressExistException } from 'src/exceptions'
import { EMAIL_EXIST_ERR_MSG } from 'src/exceptions/message.constant'
import { UserNotFoundException } from 'src/exceptions/user-not-found.exception'
import { UtilsService } from 'src/utils/services'
import { Repository } from 'typeorm'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'
import { UserEntity } from './entities/user.entity'

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UserEntity)
    private _usersRepository: Repository<UserEntity>,
  ) {}

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

  async findAll({ skip, limit, sort: order, page }: PageOptionsDto) {
    const x = await this._usersRepository
      .createQueryBuilder()
      .skip(skip)
      .limit(limit)
      .getMany()
    console.log(x)
    return x
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
    const user = await this.findOne(id)
    console.log(user)
    if (!UtilsService.hasAbility({ doc: user, ownerKey: 'id', user: curUser }))
      throw new ForbiddenException()

    const updatedUser = await this._usersRepository.save(
      Object.assign(user, updateUserDto),
    )
    return plainToClass(UserEntity, updatedUser)
  }

  async remove(id: string) {
    const user = await this.findOne(id)
    await this._usersRepository.delete(user)
    return null
  }
}
