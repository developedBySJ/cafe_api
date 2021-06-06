import { IsBoolean, IsOptional, IsString, Length } from 'class-validator'
import { UserEntity } from 'src/users/entities/user.entity'
import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm'

@Entity('menus')
export class MenuEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @Column({ unique: true })
  @IsString()
  @Length(3, 50)
  name: string

  @Column({ name: 'is_active', default: false })
  @IsBoolean()
  isActive: boolean

  @Column({ nullable: true })
  @IsString()
  @IsOptional()
  image?: string

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date
}
