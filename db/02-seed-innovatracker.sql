-- ============================================================================
-- SCRIPT DE CARGA DE DADOS - INNOVATRACKER  |  Tutorial 03 (igual ao material)
-- Executar no DBeaver com Alt+X, DEPOIS do 01-ddl-innovatracker.sql
-- Os hashes de senha abaixo são fictícios: o 03-senha-login.sql os substitui.
-- Se der "current transaction is aborted", rode ROLLBACK; e execute de novo.
-- Versão com o schema escrito em cada tabela (innova.xxx): funciona mesmo
-- que o DBeaver esteja com outro schema ativo na barra.
-- ============================================================================
BEGIN TRANSACTION;

-- 1. DEPARTAMENTOS
INSERT INTO innova.td_departamento (sgl_departamento, nme_departamento) VALUES
('TI', 'Tecnologia da Informação e Sistemas'),
('PND', 'Pesquisa, Desenvolvimento e Inovação'),
('MKT', 'Marketing Estratégico e Comunicação'),
('RH', 'Recursos Humanos e Gestão de Pessoas'),
('FIN', 'Finanças e Controladoria Ops'),
('OPER', 'Operações e Logística Industrial'),
('GOV', 'Governança, Risco e Compliance'),
('COM', 'Comercial e Novos Negócios');

-- 2. PESSOAS
INSERT INTO innova.tb_pessoa (cod_departamento, nme_pessoa, eml_pessoa, pwd_pessoa, dta_nascimento_pessoa, flg_ativo_pessoa, dtt_criacao_pessoa) VALUES
(1, 'Carlos Eduardo Silva', 'carlos.silva@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0a', '1988-04-12', TRUE, '2025-01-10 08:30:00'),
(1, 'Mariana Costa', 'mariana.costa@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0b', '1992-09-25', TRUE, '2025-01-10 09:15:00'),
(2, 'Dr. Roberto Alves', 'roberto.alves@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0c', '1979-11-03', TRUE, '2025-01-11 10:00:00'),
(2, 'Beatriz Lima', 'beatriz.lima@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0d', '1995-02-18', TRUE, '2025-01-11 11:20:00'),
(3, 'Fernando Rocha', 'fernando.rocha@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0e', '1990-07-08', TRUE, '2025-01-12 14:00:00'),
(4, 'Juliana Mendes', 'juliana.mendes@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0f', '1985-05-30', TRUE, '2025-01-12 16:45:00'),
(5, 'Ricardo Martins', 'ricardo.martins@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0g', '1982-12-14', TRUE, '2025-01-13 09:00:00'),
(6, 'Patricia Souza', 'patricia.souza@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0h', '1993-08-22', TRUE, '2025-01-14 11:10:00'),
(7, 'Gabriel Torres', 'gabriel.torres@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0i', '1987-03-19', TRUE, '2025-01-15 13:20:00'),
(8, 'Vanessa Oliveira', 'vanessa.oliveira@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0j', '1991-06-05', TRUE, '2025-01-15 15:40:00'),
(1, 'Lucas Xavier', 'lucas.xavier@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0k', '1996-10-30', TRUE, '2025-01-16 10:00:00'),
(6, 'Camila Barbosa', 'camila.barbosa@innovatracker.com', '$2a$10$7vP1/qI9Y3u2m6k2g8R.uO3z9fJ9L8y0m1k2g3r4t5y6u7i8o9p0l', '1989-01-22', TRUE, '2025-01-16 11:30:00');

-- 3. CATEGORIAS
INSERT INTO innova.td_categoria (sgl_categoria, nme_categoria, dsc_categoria) VALUES
('IA_AUTOM', 'Inteligência Artificial e Automação', 'Ideias voltadas à automação de processos internos e algoritmos inteligentes.'),
('SUSTENT', 'Sustentabilidade e ESG', 'Iniciativas de redução de pegada de carbono, eficiência energética e logística reversa.'),
('CX_EXP', 'Experiência do Cliente (CX)', 'Melhorias diretas em canais de atendimento, usabilidade e satisfação do usuário final.'),
('OTIM_PROC', 'Otimização de Processos', 'Propostas para eliminação de gargalos operacionais e redução de custos logísticos.'),
('SEG_DADOS', 'Segurança da Informação e Privacidade', 'Iniciativas para fortalecimento de segurança cibernética e compliance com LGPD.');

-- 4. IDEIAS
INSERT INTO innova.tb_ideia (cod_pessoa, cod_categoria, nme_ideia, txt_resumo_ideia, vlr_orcamento_ideia, sts_ideia, dtt_criacao_ideia) VALUES
(2, 1, 'Agente Virtual de Triagem com IA Generativa', 'Implementar assistente virtual com suporte LLM para triagem automática de chamados técnicos internos.', 45000.00, 'B', '2025-02-01 10:00:00'),
(4, 2, 'Sistema Solar On-Grid nos Galpões Operacionais', 'Instalação de painéis fotovoltaicos para reduzir consumo de energia da rede em 30%.', 120000.00, 'B', '2025-02-03 14:30:00'),
(5, 3, 'Plataforma Omnichannel de Pesquisas de Satisfação', 'Unificação dos canais WhatsApp, e-mail e app para avaliação NPS em tempo real.', 28000.00, 'M', '2025-02-05 09:15:00'),
(8, 4, 'Rastreamento IoT para Cargas de Alto Valor', 'Sensores IoT para monitoramento térmico e localização em tempo real da frota.', 65000.00, 'M', '2025-02-10 16:00:00'),
(1, 1, 'Refatoração da Arquitetura para Microsserviços', 'Migração de batch legado para arquitetura event-driven com Apache Kafka.', 95000.00, 'A', '2025-02-12 11:20:00'),
(10, 3, 'Portal Self-Service para Parceiros B2B', 'Portal web responsivo para consulta de pedidos, notas e ordens de serviço em tempo real.', 35000.00, 'A', '2025-02-15 13:00:00'),
(9, 5, 'Zero-Trust Architecture para Acessos Remotos', 'Implementação de autenticação multifator contínua e controle por contexto de risco.', 80000.00, 'D', '2025-02-18 10:10:00'),
(12, 4, 'Otimização de Rotas de Entrega Urbana', 'Algoritmo de roteirização considerando tráfego em tempo real para redução de combustível.', 52000.00, 'D', '2025-02-20 14:25:00');

-- 5. AVALIAÇÕES
INSERT INTO innova.ta_avaliacao (cod_ideia, cod_pessoa, qtd_nota_avaliacao, txt_parecer_avaliacao, dtt_criacao_avaliacao) VALUES
(1, 3, 9, 'Excelente proposta tecnológica. ROI estimado em curto prazo e grande viabilidade de execução.', '2025-02-02 11:00:00'),
(1, 7, 8, 'Orçamento condizente com o mercado. Aprovado sob o ponto de vista de viabilidade financeira.', '2025-02-02 15:30:00'),
(1, 9, 9, 'Conformidade com os padrões de segurança de dados mantida. Proposta aprovada.', '2025-02-03 09:00:00'),
(2, 7, 10, 'Iniciativa altamente estratégica para as metas globais de ESG. Retorno previsto em 24 meses.', '2025-02-04 10:20:00'),
(2, 8, 9, 'Impacto operacional altamente positivo. Cronograma deve considerar a concessionária de energia.', '2025-02-04 14:00:00'),
(2, 9, 8, 'Sem riscos regulatórios relevantes detectados. Parecer favorável.', '2025-02-05 11:30:00'),
(3, 3, 7, 'Boa proposta, porém demanda refinamento nos protocolos de privacidade de dados (LGPD).', '2025-02-06 16:45:00'),
(3, 5, 10, 'Alinhamento total com as diretrizes do Marketing e Experiência do Cliente para este ano.', '2025-02-07 08:30:00'),
(3, 7, 8, 'Custo benefício excelente. Aprovado para fase de planejamento.', '2025-02-07 14:15:00'),
(4, 7, 8, 'Viável financeiramente, impacto direto no SLA de atendimento logístico.', '2025-02-11 10:00:00'),
(4, 8, 10, 'Solução direta para o problema recorrente de sinistros e avarias em transporte.', '2025-02-11 15:00:00'),
(4, 9, 9, 'Contratos de fornecedores IoT aprovados preliminarmente.', '2025-02-12 09:40:00'),
(5, 7, 4, 'Custo de migração excessivamente elevado para o cenário financeiro atual.', '2025-02-13 09:30:00'),
(5, 3, 6, 'Apesar dos ganhos técnicos, o impacto na operação durante a transição é alto.', '2025-02-13 11:00:00'),
(6, 10, 8, 'Demanda recorrente de clientes chave. Impacto comercial imediato.', '2025-02-16 10:00:00'),
(6, 7, 7, 'Investimento baixo com boa estimativa de retenção de clientes.', '2025-02-16 14:20:00'),
(7, 9, 10, 'Essencial para a nova postura de segurança da informação corporativa.', '2025-02-19 09:00:00'),
(7, 1, 9, 'Arquitetura técnica viável e alinhada às melhores práticas do mercado.', '2025-02-19 16:30:00'),
(7, 7, 8, 'Impacto orçamentário absorvível pelo fundo de contingência de TI.', '2025-02-20 11:15:00');

-- 6. PROJETOS
INSERT INTO innova.tb_projeto (cod_ideia, cod_pessoa, nme_projeto, dsc_projeto, vlr_orcamento_projeto, dta_inicio_projeto, dta_previsao_fim_projeto, sts_projeto) VALUES
(1, 1, 'Projeto GenAI Triagem', 'Desenvolvimento e implantação do assistente de IA Generativa no helpdesk.', 45000.00, '2025-03-01', '2025-07-31', 'E'),
(2, 8, 'Projeto EcoEnergia Solar', 'Instalação da usina fotovoltaica nos galpões operacionais da matriz.', 120000.00, '2025-03-15', '2025-09-30', 'P'),
(4, 8, 'Projeto IoT CargoTracker', 'Sistemas de monitoramento inteligente para a frota de transporte pesado.', 65000.00, '2025-04-01', '2025-10-15', 'P');

-- 7. ALOCAÇÕES (ta_projeto_pessoa)
INSERT INTO innova.ta_projeto_pessoa (cod_projeto, cod_pessoa, dsc_papel_projeto_pessoa, dta_alocacao_projeto_pessoa, flg_ativo_projeto_pessoa) VALUES
(1, 1, 'Gerente de Projeto / Arquiteto Lead', '2025-02-25', TRUE),
(1, 2, 'Desenvolvedora Fullstack Senior', '2025-02-25', TRUE),
(1, 3, 'Especialista de Domínio / Pesquisador IA', '2025-03-01', TRUE),
(1, 11, 'Desenvolvedor Backend Junior', '2025-03-01', TRUE),
(1, 9, 'Auditor de Segurança e Compliance', '2025-03-05', TRUE),
(2, 8, 'Gerente de Projeto / Engenheiro Responsável', '2025-03-10', TRUE),
(2, 4, 'Analista de Processos e Inovação', '2025-03-10', TRUE),
(2, 7, 'Analista Financeiro do Projeto', '2025-03-12', TRUE),
(2, 12, 'Coordenadora de Instalações Campo', '2025-03-15', TRUE),
(3, 8, 'Gerente de Projeto Geral', '2025-03-20', TRUE),
(3, 11, 'Desenvolvedor IoT / Embedded Systems', '2025-03-22', TRUE),
(3, 2, 'Engenheira de Software / Integradora', '2025-03-22', TRUE),
(3, 6, 'Analista de RH / Treinamento Operacional', '2025-03-25', TRUE),
(3, 12, 'Supervisora de Campo e Logística', '2025-03-25', TRUE);

-- 8. APONTAMENTOS
INSERT INTO innova.tb_apontamento (cod_projeto_pessoa, dta_apontamento, qtd_horas_apontamento, txt_descricao_apontamento, dtt_registro_apontamento) VALUES
(1, '2025-03-03', 8, 'Reunião de kickoff e definição do escopo da arquitetura de microsserviços.', '2025-03-03 17:30:00'),
(2, '2025-03-03', 6, 'Configuração inicial do repositório Spring Boot e pipeline CI/CD.', '2025-03-03 18:00:00'),
(3, '2025-03-04', 4, 'Modelagem dos prompts iniciais e homologação dos endpoints da API de IA.', '2025-03-04 16:00:00'),
(1, '2025-03-05', 8, 'Elaboração do diagrama C4 e documentação dos contratos de API.', '2025-03-05 17:00:00'),
(2, '2025-03-05', 8, 'Implementação dos DTOs e entidades do ecossistema de triagem.', '2025-03-05 18:15:00'),
(4, '2025-03-06', 7, 'Desenvolvimento das suítes de teste de integração para validação de fluxos.', '2025-03-06 17:00:00'),
(5, '2025-03-07', 5, 'Análise de vulnerabilidades nos endpoints e revisão de conformidade LGPD.', '2025-03-07 15:30:00'),
(6, '2025-03-11', 5, 'Levantamento de requisitos técnicos junto às fornecedoras de placas solares.', '2025-03-11 15:40:00'),
(7, '2025-03-12', 6, 'Análise de viabilidade ambiental e validação do fluxo operacional.', '2025-03-12 16:20:00'),
(8, '2025-03-13', 4, 'Liberação das ordens de compra e validação de fluxo de caixa.', '2025-03-13 14:00:00'),
(9, '2025-03-16', 8, 'Vistoria técnica nos galpões operacionais para preparação da infraestrutura.', '2025-03-16 17:45:00'),
(10, '2025-03-21', 4, 'Planejamento de escopo inicial para implantação de dispositivos IoT.', '2025-03-21 11:30:00'),
(11, '2025-03-23', 8, 'Testes de bancada e homologação de firmware para sensores térmicos.', '2025-03-23 18:00:00'),
(12, '2025-03-24', 6, 'Desenvolvimento do gateway de mensageria MQTT no backend.', '2025-03-24 17:10:00'),
(13, '2025-03-26', 5, 'Desenho do plano de capacitação para motoristas e fiscais de frota.', '2025-03-26 16:00:00');

COMMIT;
