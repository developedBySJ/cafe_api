import { MenuItemEntity } from 'src/menu-items/entities/menu-item.entity'
import { Connection, ViewColumn, ViewEntity } from 'typeorm'
import { UserItemEntity, USER_ITEMS } from './user-item.entity'
import { UserEntity } from '../../users/entities/user.entity'

@ViewEntity({
  expression: (connection: Connection) =>
    connection
      .createQueryBuilder()
      .select(`${USER_ITEMS}.id`, 'id')
      .addSelect(`${USER_ITEMS}.user`, 'user')
      .addSelect(`${USER_ITEMS}.menu_items`, 'menu_items')
      .addSelect(`${USER_ITEMS}.created_at`, 'created_at')
      .from(UserItemEntity, USER_ITEMS)
      .where(`${USER_ITEMS}.qty IS NOT NULL`),
})
export class Carts {
  @ViewColumn()
  id: string

  @ViewColumn()
  user: UserEntity

  @ViewColumn({ name: 'menu_items' })
  menuItem: MenuItemEntity

  @ViewColumn()
  qty: number

  @ViewColumn({ name: 'created_at' })
  createdAt: Date
}
