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
