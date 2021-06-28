import { Length, Max, Min } from 'class-validator'
import { MenuItemEntity } from 'src/menu-items/entities/menu-item.entity'
import { UserEntity } from 'src/users/entities/user.entity'
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  Unique,
} from 'typeorm'

@Entity('reviews')
@Unique(['user', 'menuItem'])
export class ReviewEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @ManyToOne(() => MenuItemEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'menu_item' })
  menuItem: MenuItemEntity

  @Length(3, 50)
  @Column()
  title: string

  @Length(3, 200)
  @Column()
  comment: string

  @Column({ nullable: true })
  image?: string

  @Min(1)
  @Max(5)
  @Column('integer')
  ratings: number

  @ManyToOne(() => UserEntity, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'created_by' })
  createdBy: UserEntity

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date
}
