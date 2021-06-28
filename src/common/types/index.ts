export enum UserRole {
  Admin = 'admin',
  Manager = 'manager',
  Cashier = 'cashier',
  Chef = 'chef',
  Waiter = 'waiter',
  Customer = 'customer',
}

export interface JWTPayload {
  userId: string
  email: string
  role: UserRole
}
export interface RefreshTokenPayload {
  userId: string
}

export enum Sort {
  ASC = 'ASC',
  DESC = 'DESC',
}

export enum AssetFormat {
  Image = 'image',
  Video = 'video',
  Document = 'document',
}

export enum AssetType {
  Avatar = 'avatar',
  Review = 'review',
  MenuItem = 'menuItem',
  Menu = 'menu',
  Other = 'other',
}
