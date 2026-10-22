-- ============================================================================
-- 03 - SENHA REAL PARA O LOGIN (Tutorial 07)
-- 1) Com a API rodando, faça um POST /api/auth/login no Swagger
--    (email carlos.silva@innovatracker.com, senha 654321). Vai dar 401: é esperado.
-- 2) No console do IntelliJ, copie o valor da linha "Hash gerado pelo Java: ..."
--    (é o hash BCrypt de 654321, a senha definida no AuthService).
-- 3) Cole o hash entre as aspas abaixo e execute com Alt+X.
-- As 12 pessoas do seed passam a ter a senha 654321.
-- ============================================================================
UPDATE innova.tb_pessoa SET pwd_pessoa = 'COLE_AQUI_O_HASH';

-- Conferência: as 12 linhas devem começar com $2a$10$ e ter 60 caracteres
SELECT idt_pessoa, eml_pessoa, LEFT(pwd_pessoa, 7) AS inicio_hash, LENGTH(pwd_pessoa) AS tamanho
FROM innova.tb_pessoa
ORDER BY idt_pessoa;
