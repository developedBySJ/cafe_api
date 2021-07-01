class Pages {
  next: string | null
  prev: string | null
  first: string
  last: string
}

export class PaginationResponseDto<T> {
  result: T
  totalCount: number
  totalPages: number
  pages: Pages
}
