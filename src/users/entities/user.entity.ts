import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm'
import {
  IsDate,
  IsEmail,
  IsEnum,
  IsOptional,
  IsString,
  Length,
  MinDate,
} from 'class-validator'
import { Exclude } from 'class-transformer'
import { UserRole } from 'src/common/types'

@Entity('users')
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @Column('varchar', { name: 'first_name', length: 64 })
  @Length(3, 64)
  @IsString()
  firstName: string

  @Column('varchar', { name: 'last_name', length: 64, nullable: true })
  @Length(3, 64)
  @IsString()
  @IsOptional()
  lastName: string

  @Column('varchar', { length: 100, nullable: false, unique: true })
  @IsEmail()
  @Length(3, 100)
  email: string

  @Column()
  @IsString()
  @Exclude()
  password: string

  @Column('timestamp with time zone', { name: 'date_of_birth', nullable: true })
  @MinDate(new Date())
  @IsDate()
  @IsOptional()
  dateOfBirth: Date

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.Customer,
  })
  @IsString()
  @IsEnum(UserRole)
  role: UserRole

  @Column('varchar', { length: 255, nullable: true })
  @IsString()
  @IsOptional()
  address: string

  @Column('varchar', { length: 512, nullable: true })
  @Length(3, 512)
  @IsString()
  @IsOptional()
  avatar: string

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date
}
