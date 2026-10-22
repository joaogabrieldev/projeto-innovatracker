-- ============================================================================
-- SCRIPT DE CRIAÇÃO DO ESQUEMA FÍSICO DE DADOS - INNOVATRACKER
-- BANCO DE DADOS: PostgreSQL  |  Tutorial 03 (igual ao material)
-- Executar no DBeaver com Alt+X, na conexão do banco innovatracker
-- ATENÇÃO: apaga e recria as tabelas (rode o 02 e o 03 de novo depois)
-- ============================================================================

-- Cria o schema (se ainda não existir). Todas as tabelas abaixo são escritas como
-- innova.xxx, então o script funciona qualquer que seja o schema ativo no DBeaver.
CREATE SCHEMA IF NOT EXISTS innova;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Limpeza de tabelas existentes (Ordem reversa de dependência)
DROP TABLE IF EXISTS innova.tb_apontamento CASCADE;
DROP TABLE IF EXISTS innova.ta_projeto_pessoa CASCADE;
DROP TABLE IF EXISTS innova.tb_projeto CASCADE;
DROP TABLE IF EXISTS innova.ta_avaliacao CASCADE;
DROP TABLE IF EXISTS innova.tb_ideia CASCADE;
DROP TABLE IF EXISTS innova.td_categoria CASCADE;
DROP TABLE IF EXISTS innova.tb_pessoa CASCADE;
DROP TABLE IF EXISTS innova.td_departamento CASCADE;

-- 1. TABELA DESCRITIVA: td_departamento
CREATE TABLE innova.td_departamento (
    idt_departamento BIGSERIAL NOT NULL,
    sgl_departamento VARCHAR(10) NOT NULL,
    nme_departamento VARCHAR(80) NOT NULL,
    CONSTRAINT pk_departamento PRIMARY KEY (idt_departamento),
    CONSTRAINT uk_departamento_sgl_departamento UNIQUE (sgl_departamento)
);

-- 2. TABELA BÁSICA: tb_pessoa
CREATE TABLE innova.tb_pessoa (
    idt_pessoa BIGSERIAL NOT NULL,
    cod_departamento BIGINT NOT NULL,
    nme_pessoa VARCHAR(80) NOT NULL,
    eml_pessoa VARCHAR(80) NOT NULL,
    pwd_pessoa VARCHAR(128) NOT NULL,
    dta_nascimento_pessoa DATE NOT NULL,
    flg_ativo_pessoa BOOLEAN NOT NULL DEFAULT TRUE,
    dtt_criacao_pessoa TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_pessoa PRIMARY KEY (idt_pessoa),
    CONSTRAINT uk_pessoa_eml_pessoa UNIQUE (eml_pessoa),
    CONSTRAINT fk_departamento_pessoa FOREIGN KEY (cod_departamento)
        REFERENCES innova.td_departamento (idt_departamento)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 3. TABELA DESCRITIVA: td_categoria
CREATE TABLE innova.td_categoria (
    idt_categoria BIGSERIAL NOT NULL,
    sgl_categoria VARCHAR(10) NOT NULL,
    nme_categoria VARCHAR(80) NOT NULL,
    dsc_categoria VARCHAR(200) NOT NULL,
    CONSTRAINT pk_categoria PRIMARY KEY (idt_categoria),
    CONSTRAINT uk_categoria_sgl_categoria UNIQUE (sgl_categoria)
);

-- 4. TABELA BÁSICA: tb_ideia
CREATE TABLE innova.tb_ideia (
    idt_ideia BIGSERIAL NOT NULL,
    cod_pessoa BIGINT NOT NULL,
    cod_categoria BIGINT NOT NULL,
    nme_ideia VARCHAR(80) NOT NULL,
    txt_resumo_ideia TEXT NOT NULL,
    vlr_orcamento_ideia NUMERIC(12,2) NOT NULL,
    sts_ideia CHAR(1) NOT NULL,
    dtt_criacao_ideia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_ideia PRIMARY KEY (idt_ideia),
    CONSTRAINT fk_pessoa_ideia FOREIGN KEY (cod_pessoa)
        REFERENCES innova.tb_pessoa (idt_pessoa)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_categoria_ideia FOREIGN KEY (cod_categoria)
        REFERENCES innova.td_categoria (idt_categoria)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_ideia_sts_ideia CHECK (sts_ideia IN ('B', 'M', 'A', 'D')),
    CONSTRAINT ck_ideia_vlr_orcamento_ideia CHECK (vlr_orcamento_ideia >= 0)
);

-- 5. TABELA ASSOCIATIVA: ta_avaliacao
CREATE TABLE innova.ta_avaliacao (
    idt_avaliacao BIGSERIAL NOT NULL,
    cod_ideia BIGINT NOT NULL,
    cod_pessoa BIGINT NOT NULL,              -- Avaliador
    qtd_nota_avaliacao INT NOT NULL,         -- Nota de 1 a 10
    txt_parecer_avaliacao TEXT NOT NULL,
    dtt_criacao_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_avaliacao PRIMARY KEY (idt_avaliacao),
    CONSTRAINT fk_ideia_avaliacao FOREIGN KEY (cod_ideia)
        REFERENCES innova.tb_ideia (idt_ideia)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pessoa_avaliacao FOREIGN KEY (cod_pessoa)
        REFERENCES innova.tb_pessoa (idt_pessoa)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_avaliacao_qtd_nota_avaliacao CHECK (qtd_nota_avaliacao BETWEEN 1 AND 10)
);

-- 6. TABELA BÁSICA: tb_projeto
CREATE TABLE innova.tb_projeto (
    idt_projeto BIGSERIAL NOT NULL,
    cod_ideia BIGINT NOT NULL,
    cod_pessoa BIGINT NOT NULL,              -- Gerente do Projeto
    nme_projeto VARCHAR(80) NOT NULL,
    dsc_projeto VARCHAR(200) NOT NULL,
    vlr_orcamento_projeto NUMERIC(12,2) NOT NULL,
    dta_inicio_projeto DATE NOT NULL,
    dta_previsao_fim_projeto DATE NOT NULL,
    sts_projeto CHAR(1) NOT NULL,
    CONSTRAINT pk_projeto PRIMARY KEY (idt_projeto),
    CONSTRAINT uk_projeto_cod_ideia UNIQUE (cod_ideia),
    CONSTRAINT fk_ideia_projeto FOREIGN KEY (cod_ideia)
        REFERENCES innova.tb_ideia (idt_ideia)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pessoa_projeto FOREIGN KEY (cod_pessoa)
        REFERENCES innova.tb_pessoa (idt_pessoa)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_projeto_sts_projeto CHECK (sts_projeto IN ('R', 'A', 'P', 'E', 'C', 'X')),
    CONSTRAINT ck_projeto_vlr_orcamento_projeto CHECK (vlr_orcamento_projeto >= 0)
);

-- 7. TABELA ASSOCIATIVA: ta_projeto_pessoa
CREATE TABLE innova.ta_projeto_pessoa (
    idt_projeto_pessoa BIGSERIAL NOT NULL,
    cod_projeto BIGINT NOT NULL,
    cod_pessoa BIGINT NOT NULL,
    dsc_papel_projeto_pessoa VARCHAR(200) NOT NULL,
    dta_alocacao_projeto_pessoa DATE NOT NULL DEFAULT CURRENT_DATE,
    flg_ativo_projeto_pessoa BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_projeto_pessoa PRIMARY KEY (idt_projeto_pessoa),
    CONSTRAINT uk_projeto_pessoa_cod_projeto_cod_pessoa UNIQUE (cod_projeto, cod_pessoa),
    CONSTRAINT fk_projeto_projeto_pessoa FOREIGN KEY (cod_projeto)
        REFERENCES innova.tb_projeto (idt_projeto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pessoa_projeto_pessoa FOREIGN KEY (cod_pessoa)
        REFERENCES innova.tb_pessoa (idt_pessoa)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 8. TABELA BÁSICA: tb_apontamento
CREATE TABLE innova.tb_apontamento (
    idt_apontamento BIGSERIAL NOT NULL,
    cod_projeto_pessoa BIGINT NOT NULL,
    dta_apontamento DATE NOT NULL,
    qtd_horas_apontamento INT NOT NULL,
    txt_descricao_apontamento TEXT NOT NULL,
    dtt_registro_apontamento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_apontamento PRIMARY KEY (idt_apontamento),
    CONSTRAINT fk_projeto_pessoa_apontamento FOREIGN KEY (cod_projeto_pessoa)
        REFERENCES innova.ta_projeto_pessoa (idt_projeto_pessoa)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_apontamento_qtd_horas CHECK (qtd_horas_apontamento BETWEEN 1 AND 1000)
);

-- ÍNDICES PARA OTIMIZAÇÃO DE CONSULTAS E CHAVES ESTRANGEIRAS
CREATE INDEX idx_tb_pessoa_cod_departamento ON innova.tb_pessoa(cod_departamento);
CREATE INDEX idx_tb_ideia_cod_pessoa ON innova.tb_ideia(cod_pessoa);
CREATE INDEX idx_tb_ideia_cod_categoria ON innova.tb_ideia(cod_categoria);
CREATE INDEX idx_tb_ideia_sts_ideia ON innova.tb_ideia(sts_ideia);
CREATE INDEX idx_ta_avaliacao_cod_ideia ON innova.ta_avaliacao(cod_ideia);
CREATE INDEX idx_tb_projeto_cod_pessoa ON innova.tb_projeto(cod_pessoa);
CREATE INDEX idx_ta_projeto_pessoa_cod_projeto ON innova.ta_projeto_pessoa(cod_projeto);
CREATE INDEX idx_ta_projeto_pessoa_cod_pessoa ON innova.ta_projeto_pessoa(cod_pessoa);
CREATE INDEX idx_tb_apontamento_cod_projeto_pessoa ON innova.tb_apontamento(cod_projeto_pessoa);
