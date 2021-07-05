import { ApiProperty } from '@nestjs/swagger'
import { Exclude, Type } from 'class-transformer'

class Pages {
  next: string | null
  prev: string | null
  first: string
  last: string
}

export class PaginationResponseDto<T> {
  @Exclude()
  private type?: Function

  @ApiProperty()
  @Type((options) => {
    return (options.newObject as PaginationResponseDto<T>).type
  })
  result: T

  @ApiProperty()
  totalCount: number

  @ApiProperty()
  totalPages: number

  @ApiProperty()
  pages: Pages
}
