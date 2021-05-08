import { Injectable, NotFoundException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
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
    const newUser = await this.usersRepository.create(user)
    await this.usersRepository.save(newUser)
    return newUser
  }

  findAll() {
    return this.usersRepository.find({})
  }

  async findOne(id: string) {
    const user = await this.usersRepository.findOne({ id })
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
