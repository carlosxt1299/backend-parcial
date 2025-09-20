# NestJS Tasks API Backend

A complete REST API backend built with NestJS, TypeORM, PostgreSQL, and JWT authentication for task management.

## 🚀 Features

- **Authentication & Authorization**
  - JWT-based authentication
  - User registration and login
  - Protected routes with guards
  - Password hashing with bcrypt (10 salt rounds)

- **Task Management (CRUD)**
  - Create, read, update, and delete tasks
  - User-specific task isolation
  - Task completion status tracking

- **Security & Validation**
  - Input validation with class-validator
  - SQL injection protection
  - Rate limiting for authentication endpoints
  - CORS configuration
  - Global exception handling

- **Database**
  - PostgreSQL with TypeORM
  - Database migrations
  - Entity relationships (User ↔ Tasks)

## 🛠 Tech Stack

- **Framework:** NestJS 11+ with TypeScript
- **Database:** PostgreSQL with TypeORM
- **Authentication:** JWT with Passport
- **Validation:** class-validator & class-transformer
- **Security:** bcrypt, @nestjs/throttler
- **Environment:** @nestjs/config

## 📁 Project Structure

```
src/
├── auth/
│   ├── auth.module.ts
│   ├── auth.controller.ts
│   ├── auth.service.ts
│   ├── dto/
│   │   ├── login.dto.ts
│   │   └── register.dto.ts
│   ├── strategies/
│   │   └── jwt.strategy.ts
│   └── guards/
│       └── jwt-auth.guard.ts
├── tasks/
│   ├── tasks.module.ts
│   ├── tasks.controller.ts
│   ├── tasks.service.ts
│   ├── entities/
│   │   └── task.entity.ts
│   ├── dto/
│   │   ├── create-task.dto.ts
│   │   └── update-task.dto.ts
│   └── repositories/
│       └── tasks.repository.ts
├── users/
│   ├── users.module.ts
│   ├── users.service.ts
│   └── entities/
│       └── user.entity.ts
├── common/
│   ├── filters/
│   │   └── http-exception.filter.ts
│   └── decorators/
│       └── get-user.decorator.ts
├── database/
│   └── migrations/
│       └── 1700000000000-InitialMigration.ts
└── app.module.ts
```

## 🚦 Getting Started

### Prerequisites

- Node.js (v18 or higher)
- npm or yarn
- PostgreSQL database

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment Configuration**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` with your database and JWT configuration:
   ```env
   # Database Configuration
   DATABASE_HOST=localhost
   DATABASE_PORT=5432
   DATABASE_USERNAME=postgres
   DATABASE_PASSWORD=your_password
   DATABASE_NAME=tasks_db

   # JWT Configuration
   JWT_SECRET=your-super-secret-jwt-key-here
   JWT_EXPIRATION=7d

   # Application Configuration
   PORT=3000
   NODE_ENV=development

   # CORS Configuration
   CORS_ORIGIN=http://localhost:3001
   ```

4. **Database Setup**
   
   Create the PostgreSQL database:
   ```sql
   CREATE DATABASE tasks_db;
   ```

5. **Run Migrations**
   ```bash
   npm run migration:run
   ```

6. **Start the Development Server**
   ```bash
   npm run start:dev
   ```

The API will be available at `http://localhost:3000/api`

## 📚 API Endpoints

### Authentication (Public)

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Login User
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Get User Profile (Protected)
```http
GET /api/auth/profile
Authorization: Bearer <your-jwt-token>
```

### Tasks (Protected - Require JWT Token)

#### Create Task
```http
POST /api/tasks
Authorization: Bearer <your-jwt-token>
Content-Type: application/json

{
  "title": "Complete project documentation",
  "description": "Write comprehensive README and API docs"
}
```

#### Get All User Tasks
```http
GET /api/tasks
Authorization: Bearer <your-jwt-token>
```

#### Get Task by ID
```http
GET /api/tasks/:id
Authorization: Bearer <your-jwt-token>
```

#### Update Task
```http
PATCH /api/tasks/:id
Authorization: Bearer <your-jwt-token>
Content-Type: application/json

{
  "title": "Updated task title",
  "description": "Updated description",
  "done": true
}
```

#### Delete Task
```http
DELETE /api/tasks/:id
Authorization: Bearer <your-jwt-token>
```

## 🗃 Database Schema

### Users Table
- `id` (Primary Key, Auto-increment)
- `email` (Unique, Required)
- `password` (Hashed, Required)
- `isActive` (Boolean, Default: true)
- `createdAt` (Timestamp)
- `updatedAt` (Timestamp)

### Tasks Table
- `id` (Primary Key, Auto-increment)
- `title` (Required, Max: 255 chars)
- `description` (Optional, Text)
- `done` (Boolean, Default: false)
- `userId` (Foreign Key → users.id)
- `createdAt` (Timestamp)
- `updatedAt` (Timestamp)

## 🛡 Security Features

- **Password Hashing:** bcrypt with 10 salt rounds
- **JWT Authentication:** Secure token-based auth
- **Input Validation:** class-validator on all DTOs
- **Rate Limiting:** Throttling on auth endpoints
- **SQL Injection Protection:** TypeORM parameterized queries
- **CORS Configuration:** Configurable cross-origin requests

## 🧪 Scripts

```bash
# Development
npm run start:dev          # Start with hot reload
npm run start:debug        # Start in debug mode

# Building
npm run build              # Build for production
npm run start:prod         # Start production server

# Database
npm run migration:generate # Generate new migration
npm run migration:run      # Run pending migrations
npm run migration:revert   # Revert last migration

# Testing
npm run test               # Run unit tests
npm run test:e2e          # Run end-to-end tests
npm run test:cov          # Run tests with coverage

# Code Quality
npm run lint              # Run ESLint
npm run format           # Format code with Prettier
```

## 🚨 Error Handling

The API includes comprehensive error handling:

- **400 Bad Request:** Invalid input data
- **401 Unauthorized:** Invalid credentials or missing token
- **404 Not Found:** Resource not found
- **409 Conflict:** Duplicate email registration
- **429 Too Many Requests:** Rate limit exceeded
- **500 Internal Server Error:** Server errors

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_HOST` | PostgreSQL host | localhost |
| `DATABASE_PORT` | PostgreSQL port | 5432 |
| `DATABASE_USERNAME` | Database username | postgres |
| `DATABASE_PASSWORD` | Database password | - |
| `DATABASE_NAME` | Database name | tasks_db |
| `JWT_SECRET` | JWT signing secret | - |
| `JWT_EXPIRATION` | Token expiration time | 7d |
| `PORT` | Application port | 3000 |
| `NODE_ENV` | Environment | development |
| `CORS_ORIGIN` | Allowed CORS origin | http://localhost:3001 |

## 📝 License

This project is licensed under the UNLICENSED License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

For support and questions, please open an issue in the repository.
  <!--[![Backers on Open Collective](https://opencollective.com/nest/backers/badge.svg)](https://opencollective.com/nest#backer)
  [![Sponsors on Open Collective](https://opencollective.com/nest/sponsors/badge.svg)](https://opencollective.com/nest#sponsor)-->

## Description

[Nest](https://github.com/nestjs/nest) framework TypeScript starter repository.

## Project setup

```bash
$ npm install
```

## Compile and run the project

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Run tests

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Deployment

When you're ready to deploy your NestJS application to production, there are some key steps you can take to ensure it runs as efficiently as possible. Check out the [deployment documentation](https://docs.nestjs.com/deployment) for more information.

If you are looking for a cloud-based platform to deploy your NestJS application, check out [Mau](https://mau.nestjs.com), our official platform for deploying NestJS applications on AWS. Mau makes deployment straightforward and fast, requiring just a few simple steps:

```bash
$ npm install -g @nestjs/mau
$ mau deploy
```

With Mau, you can deploy your application in just a few clicks, allowing you to focus on building features rather than managing infrastructure.

## Resources

Check out a few resources that may come in handy when working with NestJS:

- Visit the [NestJS Documentation](https://docs.nestjs.com) to learn more about the framework.
- For questions and support, please visit our [Discord channel](https://discord.gg/G7Qnnhy).
- To dive deeper and get more hands-on experience, check out our official video [courses](https://courses.nestjs.com/).
- Deploy your application to AWS with the help of [NestJS Mau](https://mau.nestjs.com) in just a few clicks.
- Visualize your application graph and interact with the NestJS application in real-time using [NestJS Devtools](https://devtools.nestjs.com).
- Need help with your project (part-time to full-time)? Check out our official [enterprise support](https://enterprise.nestjs.com).
- To stay in the loop and get updates, follow us on [X](https://x.com/nestframework) and [LinkedIn](https://linkedin.com/company/nestjs).
- Looking for a job, or have a job to offer? Check out our official [Jobs board](https://jobs.nestjs.com).

## Support

Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

## Stay in touch

- Author - [Kamil Myśliwiec](https://twitter.com/kammysliwiec)
- Website - [https://nestjs.com](https://nestjs.com/)
- Twitter - [@nestframework](https://twitter.com/nestframework)

## License

Nest is [MIT licensed](https://github.com/nestjs/nest/blob/master/LICENSE).
