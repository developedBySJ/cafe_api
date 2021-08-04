import { PartialType, PickType } from '@nestjs/swagger'
import { CreateUserItemDto } from './create-user-item.dto'

export class UpdateUserItemDto extends PickType(CreateUserItemDto, ['qty']) {}
