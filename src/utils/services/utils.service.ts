import { string } from '@hapi/joi'
import * as bcrypt from 'bcrypt'
import { UserRole } from 'src/common'
import { UserEntity } from 'src/users/entities/user.entity'

export class UtilsService {
  static async hashPassword(password: string): Promise<string> {
    const hashedPassword = await bcrypt.hash(password, 10)
    return hashedPassword
  }

  static async comparePassword(
    password: string,
    hashedPassword: string,
  ): Promise<boolean> {
    const isValidPassword = await bcrypt.compare(password, hashedPassword)
    return isValidPassword
  }

  static hasAbility({
    doc,
    ownerKey = 'user_id',
    user,
  }: {
    user: UserEntity
    doc: any
    ownerKey: string
  }) {
    const isAdmin = user.role === UserRole.Admin
    const isOwner = String(doc[ownerKey]) === String(user.id)

    return isAdmin || isOwner
  }
  static clean(obj) {
    return Object.entries(obj)
      .filter(([_, v]) => v != null)
      .reduce((acc, [k, v]) => ({ ...acc, [k]: v }), {})
  }
}
