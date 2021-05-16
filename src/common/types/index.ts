export enum UserRole {
  Admin = 'admin',
  Customer = 'customer',
}

export interface JWTPayload {
  userId: string
  email: string
  role: UserRole
}

export enum Order {
  ASC = 'ASC',
  DESC = 'DESC',
}
