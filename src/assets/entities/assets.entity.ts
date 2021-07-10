import { IsEnum } from 'class-validator'
import { AssetType } from 'src/common'
import { UserEntity } from 'src/users/entities/user.entity'
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm'

@Entity('assets')
export class AssetEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @Column({ name: 'public_id', unique: true })
  publicId: string

  @Column()
  url: string

  @Column()
  format: string

  @Column({ type: 'enum', enum: AssetType })
  @IsEnum(AssetType)
  type: AssetType

  @ManyToOne(() => UserEntity, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'created_by' })
  createdBy?: UserEntity

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date
}
