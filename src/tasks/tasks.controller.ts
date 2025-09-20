import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  ParseIntPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { TasksService } from './tasks.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { GetUser } from '../common/decorators/get-user.decorator';
import { User } from '../users/entities/user.entity';

@Controller('tasks')
@UseGuards(JwtAuthGuard)
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}

  /**
   * Create a new task
   * @param createTaskDto Task data
   * @param user Authenticated user
   * @returns Created task
   */
  @Post()
  @HttpCode(HttpStatus.CREATED)
  async create(
    @Body() createTaskDto: CreateTaskDto,
    @GetUser() user: User,
  ) {
    return this.tasksService.create(createTaskDto, user);
  }

  /**
   * Get all tasks for the authenticated user
   * @param user Authenticated user
   * @returns Array of tasks
   */
  @Get()
  async findAll(@GetUser() user: User) {
    return this.tasksService.findAll(user);
  }

  /**
   * Get a specific task by ID
   * @param id Task ID
   * @param user Authenticated user
   * @returns Task entity
   */
  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
    @GetUser() user: User,
  ) {
    return this.tasksService.findOne(id, user);
  }

  /**
   * Update a task
   * @param id Task ID
   * @param updateTaskDto Update data
   * @param user Authenticated user
   * @returns Updated task
   */
  @Patch(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateTaskDto: UpdateTaskDto,
    @GetUser() user: User,
  ) {
    return this.tasksService.update(id, updateTaskDto, user);
  }

  /**
   * Delete a task
   * @param id Task ID
   * @param user Authenticated user
   * @returns Success response
   */
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @GetUser() user: User,
  ) {
    await this.tasksService.remove(id, user);
  }
}
