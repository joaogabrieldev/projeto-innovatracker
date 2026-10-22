-- ============================================================================
-- 00 - CRIAR O BANCO DE DADOS
-- Rode numa conexão do DBeaver apontando para o banco "postgres",
-- com o auto-commit ligado (CREATE DATABASE não roda dentro de transação).
-- Depois, aponte a conexão para o banco "innovatracker" antes do script 01.
-- ============================================================================
CREATE DATABASE innovatracker
    WITH OWNER = postgres
    ENCODING = 'UTF8'
    TEMPLATE = template0
    CONNECTION LIMIT = -1;

-- Opcional: para ordenação em português, acrescente as duas linhas abaixo
-- antes do TEMPLATE (no Windows, use 'Portuguese_Brazil.1252' no lugar de 'pt_BR.UTF-8'):
--     LC_COLLATE = 'pt_BR.UTF-8'
--     LC_CTYPE = 'pt_BR.UTF-8'
