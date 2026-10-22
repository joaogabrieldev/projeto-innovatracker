-- ============================================================================
-- 99 - DIAGNÓSTICO: em que ponto está o banco? (execute com Alt+X)
-- ============================================================================

-- 1) Banco e schema certos? Esperado: innovatracker | 1
SELECT current_database() AS banco,
       (SELECT count(*) FROM information_schema.schemata WHERE schema_name = 'innova') AS schema_innova;

-- 2) Onde estão as 8 tabelas? Esperado: innovatracker | innova | 8
SELECT current_database() AS banco, table_schema, count(*) AS tabelas
FROM information_schema.tables
WHERE table_name IN ('td_departamento','tb_pessoa','td_categoria','tb_ideia',
                     'ta_avaliacao','tb_projeto','ta_projeto_pessoa','tb_apontamento')
GROUP BY 1, 2;

-- 3) Quantidade de registros (depois do 02). Esperado: 8 | 12 | 5 | 8 | 19 | 3 | 14 | 15
SELECT (SELECT count(*) FROM innova.td_departamento)   AS departamentos,
       (SELECT count(*) FROM innova.tb_pessoa)         AS pessoas,
       (SELECT count(*) FROM innova.td_categoria)      AS categorias,
       (SELECT count(*) FROM innova.tb_ideia)          AS ideias,
       (SELECT count(*) FROM innova.ta_avaliacao)      AS avaliacoes,
       (SELECT count(*) FROM innova.tb_projeto)        AS projetos,
       (SELECT count(*) FROM innova.ta_projeto_pessoa) AS alocacoes,
       (SELECT count(*) FROM innova.tb_apontamento)    AS apontamentos;
