import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  // Enable CORS - Actualizado para incluir múltiples orígenes
  app.enableCors({
    origin: [
      configService.get('CORS_ORIGIN') || 'http://localhost:3001',
      'http://localhost:5173', // Puerto de Vite
      'http://localhost:3000', // Por si acaso
    ],
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
    credentials: true,
    optionsSuccessStatus: 200, // Para navegadores legacy
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      disableErrorMessages: false,
    }),
  );

  // Set global prefix
  app.setGlobalPrefix('api');

  const port = configService.get('PORT') || 3000;
  await app.listen(port);

  console.log(`🚀 Application is running on: http://localhost:${port}/api`);
  console.log(`📡 CORS enabled for: localhost:3001, localhost:5173, localhost:3000`);
}
bootstrap();
