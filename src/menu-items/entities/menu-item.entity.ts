import { IsPositive, Length, Max, Min } from 'class-validator'
import { MenuEntity } from 'src/menus/entities/menu.entity'
import { UserEntity } from 'src/users/entities/user.entity'
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  Unique,
  UpdateDateColumn,
} from 'typeorm'

@Entity('menu_items')
@Unique(['title', 'menu'])
export class MenuItemEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @Length(3, 50)
  @Column()
  title: string

  @Length(3, 100)
  @Column({ nullable: true, name: 'sub_title' })
  subTitle: string

  @Column('text', { default: [], array: true })
  images: string[]

  @Column({ name: 'is_available', default: false })
  isAvailable: boolean

  @Column({ name: 'is_veg', default: false })
  isVeg: boolean

  @IsPositive()
  @Column()
  price: number

  @Min(0)
  @Max(99)
  @Column('integer', { default: 0 })
  discount: number

  @Column({ nullable: true })
  @Length(3, 1000)
  description?: string

  @Column('integer', { name: 'prep_type', nullable: true })
  prepTime?: number

  @ManyToOne(() => MenuEntity, {
    onDelete: 'CASCADE',
    eager: true,
  })
  menu: MenuEntity

  @ManyToOne(() => UserEntity, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'created_by' })
  createdBy?: UserEntity

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date
}
