#!/bin/bash

# Defina variáveis para os nomes dos arquivos e diretórios
PROJECT_DIR="meu_projeto_node"
ENV_FILE="$PROJECT_DIR/.env"
DB_JS_FILE="$PROJECT_DIR/db.js"
INDEX_JS_FILE="$PROJECT_DIR/index.js"
VIEWS_DIR="$PROJECT_DIR/views"
CATEGORIAS_EJS="$VIEWS_DIR/categorias.ejs"

# Cria a nova pasta para o projeto
echo "Criando a pasta do projeto..."
mkdir -p $PROJECT_DIR

# Navega para a pasta do projeto
cd $PROJECT_DIR

# Inicializa um novo projeto Node.js
echo "Inicializando o projeto Node.js..."
npm init -y

# Instala as dependências necessárias
echo "Instalando as dependências..."
npm install pg dotenv express ejs

# Cria o arquivo .env com as variáveis de ambiente
echo "Criando o arquivo .env..."
cat <<EOL > $ENV_FILE
DB_USER=seu_usuario
DB_HOST=localhost
DB_DATABASE=seu_banco_de_dados
DB_PASSWORD=sua_senha
DB_PORT=5432
EOL

# Cria o arquivo db.js
echo "Criando o arquivo db.js..."
cat <<EOL > $DB_JS_FILE
require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

module.exports = pool;
EOL

# Cria o diretório para as views e o arquivo EJS
echo "Criando o diretório para as views e o arquivo EJS..."
mkdir -p $VIEWS_DIR
cat <<EOL > $CATEGORIAS_EJS
<!DOCTYPE html>
<html>
<head>
  <title>Categorias</title>
  <style>
    table { width: 100%; border-collapse: collapse; }
    th, td { border: 1px solid #ddd; padding: 8px; }
    th { background-color: #f4f4f4; }
  </style>
</head>
<body>
  <h1>Categorias</h1>
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Nome</th>
        <th>Descrição</th>
      </tr>
    </thead>
    <tbody>
      <% categorias.forEach(categoria => { %>
        <tr>
          <td><%= categoria.id %></td>
          <td><%= categoria.nome %></td>
          <td><%= categoria.descricao %></td>
        </tr>
      <% }); %>
    </tbody>
  </table>
</body>
</html>
EOL

# Cria o arquivo index.js com o Express e a conexão com o banco de dados
echo "Criando o arquivo index.js..."
cat <<EOL > $INDEX_JS_FILE
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
    const result = await pool.query('SELECT * FROM Categorias');
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
EOL

# Mensagem de conclusão
echo "Configuração do projeto concluída com sucesso."
