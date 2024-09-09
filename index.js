const express = require('express');
const pool = require('./db');
const app = express();
const port = 3000;

// Configura EJS como o mecanismo de template
app.set('view engine', 'ejs');
app.set('views', './views');

// Middleware para analisar JSON
app.use(express.json());

// Rota para exibir categorias como HTML
app.get('/categorias', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Produtos ');
    res.render('categorias', { categorias: result.rows });
  } catch (err) {
    console.error('Erro ao consultar categorias', err);
    res.status(500).send('Erro interno do servidor');
  }
});

// Iniciar o servidor
app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});