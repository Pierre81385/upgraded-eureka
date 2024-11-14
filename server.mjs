import express from 'express';
import dotenv from 'dotenv';
import { Server } from 'socket.io';
import http from 'http';
import cors from 'cors';
import bodyParser from 'body-parser';
import authRoutes from './Routes/AuthRoutes.js';
import userRoutes from './Routes/UserRoutes.js';
import admin from './firebase_admin.js';
dotenv.config(); // load up the environment variables

const app = express();
const PORT = process.env.PORT || 3000;
app.use(bodyParser.json());

// Middleware (optional)
app.use(express.json());

console.log("Firebase services initialized:", {
  auth: typeof admin.auth === 'function',
  firestore: typeof admin.firestore === 'function',
  storage: typeof admin.storage === 'function',
});

// Basic route
app.get('/', (req, res) => {
    res.send('Hello, Node.js server!');
});

const corsOptions = {
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.some(o => typeof o === 'string' ? o === origin : o.test(origin))) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
};

app.use(cors(corsOptions));

app.use('/auth', authRoutes);
app.use('/users', userRoutes);

const allowedOrigins = [
    /^http:\/\/localhost(:\d+)?$/,
    "http://192.168.0.134:3000/" 
  ];

// Create HTTP server and initialize Socket.IO on the same port
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: allowedOrigins,
    methods: ["GET", "PUT", "POST", "DELETE"],
    credentials: true,
  },
});

// Configure Socket.IO
const configureSocketIO = (io) => {
  io.on('connection', (socket) => {
    console.log('A user connected on port:', io.httpServer.address().port);

    socket.on('ios', (data) => {
      console.log(`Message received on port ${io.httpServer.address().port}:`, data);
    });

    socket.on('fromFlutter', (data) => {
      console.log(`Message received on port ${io.httpServer.address().port}:`, data);
    });

    socket.on('fromReact', (data) => {
      console.log(`Message received on port ${io.httpServer.address().port}:`, data);
    });

    socket.on('disconnect', () => {
      console.log(`User disconnected from port ${io.httpServer.address().port}`);
    });
  });
};

configureSocketIO(io); // Attach Socket.IO event handlers

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});