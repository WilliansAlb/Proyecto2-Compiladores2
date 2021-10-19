const express = require('express');
const app = express();
const path = require('path');

app.use(express.static('public'));
app.use('/proyectos', express.static(__dirname + 'public/proyectos'));

app.get('/api/texto', (req, res) => {
	res.status(200).json({ errores: "errores" });
});

app.get('/faqs', (req, res) => {
    //res.render('faqs');
});

app.get('/about', (req, res) => {
    //res.status(201).sendFile(path.join(__dirname, '../views/about.html'));
});

app.use( (req, res, next) => {
    //res.status(404).sendFile(path.join(__dirname, '../views/404.html'));
    
});

app.listen(3250, () => console.log('Escuchando en el puerto 3250'));