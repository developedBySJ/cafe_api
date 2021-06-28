import { MenuItemEntity } from 'src/menu-items/entities/menu-item.entity'
import { UserEntity } from 'src/users/entities/user.entity'
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm'

export const USER_ITEMS = 'user_items'

@Entity(USER_ITEMS)
export class UserItemEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @ManyToOne(() => MenuItemEntity, { eager: true })
  @JoinColumn({ name: 'menu_item' })
  menuItem: MenuItemEntity

  @Column('integer', { nullable: true })
  qty?: number

  @ManyToOne(() => UserEntity, {
    onDelete: 'CASCADE',
    eager: false,
  })
  @JoinColumn({ name: 'created_by' })
  createdBy: UserEntity

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date
}
