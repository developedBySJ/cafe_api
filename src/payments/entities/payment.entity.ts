import { OrderEntity } from 'src/orders/entities/order.entity'
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

export enum PaymentType {
  Card = 'card',
  Cash = 'cash',
}
@Entity('payment')
export class PaymentEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @Column()
  amount: number

  @Column({ nullable: true })
  referenceId: string

  @OneToOne(() => OrderEntity, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn()
  order?: OrderEntity

  @Column('enum', { enum: PaymentType })
  type: PaymentType

  @Column()
  description: string

  @ManyToOne(() => UserEntity, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'created_by' })
  createdBy?: UserEntity

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date
}
