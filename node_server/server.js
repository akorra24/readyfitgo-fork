import express from 'express';
import cors from 'cors';  // Make sure you import cors
import fetch from 'node-fetch';

const app = express();
<<<<<<< Updated upstream
const PORT = process.env.PORT || 3000;
=======
const PORT = process.env.PORT || 3000; //TODO: Change to 3000
>>>>>>> Stashed changes

// Use CORS middleware to set CORS headers
app.use(cors({
    origin: '*',  // Adjust this if you want to be more specific
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type']
}));

app.use(express.json());

app.get('/image-proxy', async (req, res) => {
    const imageUrl = req.query.url;
    if (!imageUrl) {
        return res.status(400).send('URL parameter is required.');
    }

    try {
        const response = await fetch(imageUrl);
        if (!response.ok) {
            throw new Error(`Failed to fetch ${response.url}: ${response.status} ${response.statusText}`);
        }
        const buffer = await response.arrayBuffer();  // Use arrayBuffer
        const contentType = response.headers.get('content-type');
        
        res.set('Content-Type', contentType || 'application/octet-stream');
        res.send(Buffer.from(buffer));
    } catch (error) {
        console.error(error);
        res.status(500).send('Failed to fetch image.');
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});