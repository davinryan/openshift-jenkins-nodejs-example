const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('Hello World!'));
console.log('Successfully registered path /');

app.get('/health', (req, res) => res.send('Hello World is healthy!'));
console.log('Successfully registered path /health');

app.get('/healthz', (req, res) => res.send('Hello World is healthyz!'));
console.log('Successfully registered path /healthz');

app.listen(3000, () => console.log('Example app listening on port 3000!'));