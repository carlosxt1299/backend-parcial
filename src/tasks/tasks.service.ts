import { Injectable, NotFoundException } from '@nestjs/common';
import { TasksRepository } from './repositories/tasks.repository';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { Task } from './entities/task.entity';
import { User } from '../users/entities/user.entity';

@Injectable()
export class TasksService {
  constructor(private readonly tasksRepository: TasksRepository) {}

  /**
   * Create a new task
   * @param createTaskDto Task data
   * @param user User who owns the task
   * @returns Created task
   */
  async create(createTaskDto: CreateTaskDto, user: User): Promise<Task> {
    return this.tasksRepository.createTask(createTaskDto, user);
  }

  /**
   * Find all tasks for the authenticated user
   * @param user Authenticated user
   * @returns Array of tasks
   */
  async findAll(user: User): Promise<Task[]> {
    return this.tasksRepository.findAllByUser(user.id);
  }

  /**
   * Find a specific task by ID for the authenticated user
   * @param id Task ID
   * @param user Authenticated user
   * @returns Task entity
   * @throws NotFoundException if task not found
   */
  async findOne(id: number, user: User): Promise<Task> {
    const task = await this.tasksRepository.findOneByUser(id, user.id);
    
    if (!task) {
      throw new NotFoundException(`Task with ID ${id} not found`);
    }

    return task;
  }

  /**
   * Update a task
   * @param id Task ID
   * @param updateTaskDto Update data
   * @param user Authenticated user
   * @returns Updated task
   * @throws NotFoundException if task not found
   */
  async update(id: number, updateTaskDto: UpdateTaskDto, user: User): Promise<Task> {
    const updatedTask = await this.tasksRepository.updateTask(id, updateTaskDto, user.id);
    
    if (!updatedTask) {
      throw new NotFoundException(`Task with ID ${id} not found`);
    }

    return updatedTask;
  }

  /**
   * Delete a task
   * @param id Task ID
   * @param user Authenticated user
   * @throws NotFoundException if task not found
   */
  async remove(id: number, user: User): Promise<void> {
    const deleted = await this.tasksRepository.deleteTask(id, user.id);
    
    if (!deleted) {
      throw new NotFoundException(`Task with ID ${id} not found`);
    }
  }
}
