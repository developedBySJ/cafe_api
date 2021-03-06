import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseUUIDPipe,
  UseGuards,
  Query,
} from '@nestjs/common'
import { InventoryService } from './inventory.service'
import { CreateInventoryDto } from './dto/create-inventory.dto'
import { UpdateInventoryDto } from './dto/update-inventory.dto'
import { UpdateStocksDto } from './dto/update-stocks.dto'
import { JwtAuthGuard } from 'src/auth/guards'
import { RolesGuard } from 'src/common/guards/roles.guards'
import { Roles } from 'src/common/decorators'
import { UserRole } from 'src/common'
import { User } from 'src/common/decorators/user.decorator'
import { UserEntity } from 'src/users/entities/user.entity'
import { InventoryFilterDto } from './dto/inventory-filter.dto'
import { InventoryUsageFilterDto } from './dto/inventory-usage-filter.dto'
import { ApiTags } from '@nestjs/swagger'
import { JwtRefreshGuard } from 'src/auth/guards/refresh.guard'

@ApiTags('Inventory')
@Controller('inventory')
@UseGuards(JwtAuthGuard, JwtRefreshGuard, RolesGuard)
export class InventoryController {
  constructor(private readonly inventoryService: InventoryService) {}

  @Roles(UserRole.Admin, UserRole.Manager)
  @Post()
  create(
    @User() user: UserEntity,
    @Body() createInventoryDto: CreateInventoryDto,
  ) {
    return this.inventoryService.create(createInventoryDto, user)
  }

  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  @Get()
  findAll(@Query() pageOption: InventoryFilterDto) {
    return this.inventoryService.findAll(pageOption)
  }
  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  @Get('/usage')
  findAllUsage(@Query() pageOption: InventoryUsageFilterDto) {
    return this.inventoryService.findAllUsage(pageOption)
  }

  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.inventoryService.findOne(id)
  }

  @Roles(UserRole.Admin, UserRole.Manager)
  @Patch(':id')
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateInventoryDto: UpdateInventoryDto,
  ) {
    return this.inventoryService.update(id, updateInventoryDto)
  }

  @Roles(UserRole.Admin, UserRole.Manager, UserRole.Chef)
  @Patch(':id/stocks')
  updateStocks(
    @User() user: UserEntity,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateStocksDto: UpdateStocksDto,
  ) {
    return this.inventoryService.updateStocks(id, updateStocksDto, user)
  }

  @Roles(UserRole.Admin, UserRole.Manager)
  @Delete(':id')
  remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.inventoryService.remove(id)
  }
}
