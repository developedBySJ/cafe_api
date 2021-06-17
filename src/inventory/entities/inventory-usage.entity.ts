import { UserEntity } from 'src/users/entities/user.entity'
import {
  Column,
  CreateDateColumn,
  Entity,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm'
import { InventoryEntity } from './inventory.entity'

@Entity('inventory_usage')
export class InventoryUsageEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @ManyToOne(() => InventoryEntity, { onDelete: 'CASCADE' })
  inventory: InventoryEntity

  @ManyToOne(() => UserEntity, { onDelete: 'SET NULL', nullable: true })
  consumer?: UserEntity

  @Column()
  qty: number

  @Column({ nullable: true })
  unit?: string

  @Column({ name: 'is_added' })
  isAdded: boolean

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date
}
