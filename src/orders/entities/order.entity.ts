import { Exclude } from 'class-transformer'
import { IsEnum, Length, Min } from 'class-validator'
import { PaymentEntity } from 'src/payments/entities/payment.entity'
import { UserItemEntity } from 'src/user-items/entities/user-item.entity'
import { UserEntity } from 'src/users/entities/user.entity'
import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm'

export enum OrderStatus {
  Placed,
  Confirmed,
  Processed,
  Completed,
  Delivered,
  Cancelled,
}

@Entity('orders')
export class OrderEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @ManyToOne(() => UserEntity, { onDelete: 'CASCADE' })
  user: UserEntity

  @Column({ nullable: true })
  userEmail?: string

  @Column({ nullable: true })
  address?: string

  @OneToOne(() => PaymentEntity, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn()
  payment?: PaymentEntity

  @Column({ nullable: true })
  table?: string

  @Min(1)
  @Column()
  total: number

  @IsEnum(OrderStatus)
  @Column({ enum: OrderStatus })
  status: OrderStatus

  @Length(3, 100)
  @Column({ nullable: true })
  notes?: string

  @Column('jsonb')
  orderItems: UserItemEntity[]

  @Column({ name: 'delivered_at', nullable: true })
  deliveredAt?: Date

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date

  @Exclude()
  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date
}
