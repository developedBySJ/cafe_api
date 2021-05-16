import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { PageOptionsDto } from 'src/common/dto/page-options.dto'
import { EmailAddressExistException } from 'src/exceptions'
import { EMAIL_EXIST_ERR_MSG } from 'src/exceptions/message.constant'
import { UtilsService } from 'src/utils/services'
import { Repository } from 'typeorm'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'
import { UserEntity } from './entities/user.entity'

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UserEntity)
    private usersRepository: Repository<UserEntity>,
  ) {}

  async create(user: CreateUserDto) {
    const password = await UtilsService.hashPassword(user.password)
    const newUser = this.usersRepository.create({ ...user, password })
    try {
      await this.usersRepository.save(newUser)
      return this.findOne(newUser.id)
    } catch (error) {
      if (error?.code === '23505') {
        throw new EmailAddressExistException(EMAIL_EXIST_ERR_MSG)
      }
      throw new InternalServerErrorException()
    }
  }

  async findAll({ skip, limit, order, page }: PageOptionsDto) {
    const x = await this.usersRepository
      .createQueryBuilder()
      .offset(skip)
      .limit(limit)
      .getMany()
    console.log(x)
    return x
  }

  async findOne(id: string) {
    const user = await this.usersRepository.findOne({ id })
    if (!user) throw new NotFoundException()
    return user
  }
  async findByEmail(email: string) {
    const user = await this.usersRepository.findOne({ email })
    if (!user) throw new NotFoundException()
    return user
  }

  async update(id: string, updateUserDto: UpdateUserDto) {
    const user = await this.usersRepository.findOne({ id })

    if (!user) throw new NotFoundException()

    const updatedUser = await this.usersRepository.save({
      ...user,
      ...updateUserDto,
    })
    return updatedUser
  }

  remove(id: string) {
    return this.usersRepository.delete({ id })
  }
}
