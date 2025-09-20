import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Task } from '../entities/task.entity';
import { CreateTaskDto } from '../dto/create-task.dto';
import { UpdateTaskDto } from '../dto/update-task.dto';
import { User } from '../../users/entities/user.entity';

@Injectable()
export class TasksRepository {
  constructor(
    @InjectRepository(Task)
    private readonly taskRepository: Repository<Task>,
  ) {}

  /**
   * Create a new task
   * @param createTaskDto Task data
   * @param user User who owns the task
   * @returns Created task
   */
  async createTask(createTaskDto: CreateTaskDto, user: User): Promise<Task> {
    const task = this.taskRepository.create({
      ...createTaskDto,
      userId: user.id,
    });

    return this.taskRepository.save(task);
  }

  /**
   * Find all tasks for a specific user
   * @param userId User ID
   * @returns Array of tasks
   */
  async findAllByUser(userId: number): Promise<Task[]> {
    return this.taskRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }

  /**
   * Find a task by ID and user ID
   * @param id Task ID
   * @param userId User ID
   * @returns Task or null
   */
  async findOneByUser(id: number, userId: number): Promise<Task | null> {
    return this.taskRepository.findOne({
      where: { id, userId },
    });
  }

  /**
   * Update a task
   * @param id Task ID
   * @param updateTaskDto Update data
   * @param userId User ID
   * @returns Updated task or null
   */
  async updateTask(
    id: number,
    updateTaskDto: UpdateTaskDto,
    userId: number,
  ): Promise<Task | null> {
    const task = await this.findOneByUser(id, userId);
    
    if (!task) {
      return null;
    }

    Object.assign(task, updateTaskDto);
    return this.taskRepository.save(task);
  }

  /**
   * Delete a task
   * @param id Task ID
   * @param userId User ID
   * @returns Boolean indicating success
   */
  async deleteTask(id: number, userId: number): Promise<boolean> {
    const result = await this.taskRepository.delete({ id, userId });
    return (result.affected ?? 0) > 0;
  }
}
