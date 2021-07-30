import * as bcrypt from 'bcrypt'
import { UserRole } from 'src/common'
import { PaginationResponseDto } from 'src/common/dto/pagination-response.dto'
import { UserEntity } from 'src/users/entities/user.entity'

interface IPaginationResponseArgs<T, M> {
  data: [T, number]
  curPage: number
  limit: number
  baseUrl: string
  query?: { [key: string]: any }
  meta?: M
}

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
    access = [UserRole.Admin],
  }: {
    user: UserEntity
    doc: any
    ownerKey: string
    access?: UserRole[]
  }) {
    const isAdmin = access.includes(user.role)
    const isOwner = String(doc[ownerKey]) === String(user.id)

    return isAdmin || isOwner
  }

  static clean(obj) {
    return Object.entries(obj)
      .filter(([_, v]) => v != null)
      .reduce((acc, [k, v]) => ({ ...acc, [k]: v }), {})
  }

  static objToQuery(obj: { [key: string]: any }) {
    return new URLSearchParams(obj).toString()
  }

  static paginationResponse<T, M = undefined>({
    baseUrl,
    curPage,
    data: [result, totalCount],
    limit,
    query,
    meta,
  }: IPaginationResponseArgs<T, M>): PaginationResponseDto<T, M> {
    const totalPages = Math.ceil(totalCount / Math.max(limit, 1))
    const q = this.clean(query)

    const nextPage = curPage + 1
    const prevPage = curPage - 1

    const first =
      totalPages > 0
        ? `${baseUrl}?${this.objToQuery({
            limit,
            page: 1,
            ...q,
          })}`
        : null
    const last =
      totalPages > 0
        ? `${baseUrl}?${this.objToQuery({
            limit,
            page: totalPages,
            ...q,
          })}`
        : null
    const next =
      nextPage > totalPages
        ? null
        : `${baseUrl}?${this.objToQuery({
            limit,
            page: nextPage,
            ...q,
          })}`
    const prev =
      prevPage < 1 || prevPage > totalPages
        ? null
        : `${baseUrl}?${this.objToQuery({
            limit,
            page: prevPage,
            ...q,
          })}`

    return {
      meta,
      pages: { first, last, next, prev },
      result,
      totalCount,
      totalPages,
    }
  }
}
