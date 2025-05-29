import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { Pool } from 'pg';
import { createClient } from 'redis';
import { logger } from './utils/logger';
import { errorHandler } from './middleware/errorHandler';
import { authenticateToken } from './middleware/auth';

// Import routes
import casinoRoutes from './routes/casinos';
import reviewRoutes from './routes/reviews';
import competitorRoutes from './routes/competitors';
import keywordRoutes from './routes/keywords';
import contentRoutes from './routes/content';
import analyticsRoutes from './routes/analytics';
import workflowRoutes from './routes/workflows';

dotenv.config();

class Server {
  private app: express.Application;
  private port: number;
  public db: Pool;
  public redis: any;

  constructor() {
    this.app = express();
    this.port = parseInt(process.env.PORT || '3001');
    this.initializeDatabase();
    this.initializeRedis();
    this.initializeMiddlewares();
    this.initializeRoutes();
    this.initializeErrorHandling();
  }

  private async initializeDatabase(): Promise<void> {
    this.db = new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    });

    try {
      await this.db.query('SELECT NOW()');
      logger.info('✅ Database connected successfully');
    } catch (error) {
      logger.error('❌ Database connection failed:', error);
      process.exit(1);
    }
  }

  private async initializeRedis(): Promise<void> {
    this.redis = createClient({
      url: process.env.REDIS_URL
    });

    this.redis.on('error', (err: Error) => {
      logger.error('Redis Client Error:', err);
    });

    await this.redis.connect();
    logger.info('✅ Redis connected successfully');
  }
  private initializeMiddlewares(): void {
    // Security middleware
    this.app.use(helmet());
    this.app.use(cors({
      origin: process.env.FRONTEND_URL || 'http://localhost:3000',
      credentials: true
    }));

    // Rate limiting
    const limiter = rateLimit({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: parseInt(process.env.API_RATE_LIMIT || '1000'),
      message: 'Too many requests from this IP, please try again later.'
    });
    this.app.use(limiter);

    // General middleware
    this.app.use(compression());
    this.app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) }}));
    this.app.use(express.json({ limit: '10mb' }));
    this.app.use(express.urlencoded({ extended: true, limit: '10mb' }));

    // Make db and redis available in requests
    this.app.use((req: any, res, next) => {
      req.db = this.db;
      req.redis = this.redis;
      next();
    });
  }

  private initializeRoutes(): void {
    // Health check
    this.app.get('/', (req, res) => {
      res.json({
        status: 'success',
        message: '🎯 Casino Intelligence Platform API',
        version: '1.0.0',
        timestamp: new Date().toISOString()
      });
    });

    // API routes
    this.app.use('/api/casinos', casinoRoutes);
    this.app.use('/api/reviews', reviewRoutes);
    this.app.use('/api/competitors', competitorRoutes);
    this.app.use('/api/keywords', keywordRoutes);
    this.app.use('/api/content', contentRoutes);
    this.app.use('/api/analytics', analyticsRoutes);
    this.app.use('/api/workflows', workflowRoutes);

    // 404 handler
    this.app.use('*', (req, res) => {
      res.status(404).json({
        status: 'error',
        message: 'Endpoint not found'
      });
    });
  }

  private initializeErrorHandling(): void {
    this.app.use(errorHandler);
  }

  public listen(): void {
    this.app.listen(this.port, () => {
      logger.info(`🚀 Casino Intelligence Platform API running on port ${this.port}`);
      logger.info(`📊 Dashboard: http://localhost:3000`);
      logger.info(`🔧 n8n Workflows: http://localhost:5678`);
    });
  }
}

// Start the server
const server = new Server();
server.listen();