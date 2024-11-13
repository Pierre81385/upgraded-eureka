import express from 'express';
import axios from 'axios';
import dotenv from 'dotenv';
import { Server } from 'socket.io';
import http from 'http';

dotenv.config(); // load up the environment variables

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware (optional)
app.use(express.json());

// Basic route
app.get('/', (req, res) => {
    res.send('Hello, Node.js server!');
});

app.get('/data', async (req, res) => {
    try {
        // Make a GET request to an external API
        const response = await axios.get('https://jsonplaceholder.typicode.com/posts/1');

        // Send the response data to the client
        res.json({
            message: 'Data fetched successfully!',
            data: response.data
        });
    } catch (error) {
        console.error('Error fetching data:', error.message);
        res.status(500).json({
            message: 'Failed to fetch data',
            error: error.message
        });
    }
});

const allowedOrigins = [
    /^http:\/\/localhost(:\d+)?$/ //temporarily allow all ports on localhost
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