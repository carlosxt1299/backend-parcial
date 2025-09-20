import { IsOptional, IsString, IsBoolean, MaxLength } from 'class-validator';

export class UpdateTaskDto {
  @IsOptional()
  @IsString({ message: 'Title must be a string' })
  @MaxLength(255, { message: 'Title cannot be longer than 255 characters' })
  title?: string;

  @IsOptional()
  @IsString({ message: 'Description must be a string' })
  @MaxLength(1000, { message: 'Description cannot be longer than 1000 characters' })
  description?: string;

  @IsOptional()
  @IsBoolean({ message: 'Done must be a boolean value' })
  done?: boolean;
}
