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
  MaxDate,
} from 'class-validator'
import { Exclude, Transform } from 'class-transformer'
import { UserRole } from 'src/common/types'
import { ApiHideProperty } from '@nestjs/swagger'

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
  @Transform((email) => String(email.value).toLowerCase())
  @Length(3, 100)
  email: string

  @ApiHideProperty()
  @Column()
  @IsString()
  @Exclude()
  @ApiHideProperty()
  password: string

  @ApiHideProperty()
  @Column({
    name: 'current_hashed_refresh_token',
    nullable: true,
  })
  @Exclude()
  @IsString()
  @IsOptional()
  currentHashedRefreshToken?: string

  @Column('timestamp with time zone', { name: 'date_of_birth', nullable: true })
  @MaxDate(new Date())
  @IsDate()
  @IsOptional()
  dateOfBirth?: Date | null

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

  @ApiHideProperty()
  @Column({ name: 'password_reset_token', nullable: true })
  @Exclude()
  passwordResetToken?: string

  @ApiHideProperty()
  @Column({ name: 'password_reset_request_at', nullable: true })
  @Exclude()
  passwordResetRequestAt?: Date

  @ApiHideProperty()
  @Column({ name: 'password_reset_at', nullable: true })
  @Exclude()
  passwordResetAt?: Date

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date
}
