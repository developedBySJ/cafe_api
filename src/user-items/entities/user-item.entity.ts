import { MenuItemEntity } from 'src/menu-items/entities/menu-item.entity'
import { UserEntity } from 'src/users/entities/user.entity'
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm'

export const USER_ITEMS = 'user-items'

@Entity(USER_ITEMS)
export class UserItemEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @ManyToOne(() => UserEntity, {
    onDelete: 'CASCADE',
  })
  user: UserEntity

  @OneToOne(() => MenuItemEntity)
  @JoinColumn({ name: 'menu_item' })
  menuItem: MenuItemEntity

  @Column('integer', { nullable: true })
  qty?: number

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date
}
