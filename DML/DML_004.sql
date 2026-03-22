-- ────────────────────────────────────────
-- 1) COUNT(*) — conta TODAS as linhas da tabela
-- ────────────────────────────────────────
SELECT COUNT(*) AS total FROM notas;

-- ────────────────────────────────────────
-- 2) COUNT(coluna) — conta só onde NÃO é NULL
--    Primeiro vamos ver que na nossa base dá igual:
-- ────────────────────────────────────────
select * from disciplinas;
select count(*) from disciplinas;
select count(ementa) as tem_ementa from disciplinas;
SELECT COUNT(*) AS total_linhas, COUNT(ementa) AS com_ementa FROM disciplinas;
-- Resultado: os dois iguais (6 e 6). Tudo preenchido.

-- Agora vamos forçar um vazio (string vazia ''):
select * from disciplinas;
UPDATE disciplinas SET ementa = '' WHERE codigo = 'RED001';

SELECT COUNT(*) AS total_linhas, COUNT(ementa) AS com_ementa FROM disciplinas;
-- Resultado: AINDA iguais! '' não é NULL, é um valor vazio.
-- O banco enxerga '' como "tem algo ali", mesmo que vazio.

-- Agora vamos forçar um NULL de verdade:
UPDATE disciplinas SET ementa = NULL WHERE codigo = 'RED001';

SELECT COUNT(*) AS total_linhas, COUNT(ementa) AS com_ementa FROM disciplinas;
-- Resultado: total_linhas=6, com_ementa=5  ← agora sim a diferença aparece!
-- COUNT(coluna) PULOU o NULL.

-- Restaura o dado:
UPDATE disciplinas SET ementa = 'TCP/IP, roteamento, protocolos' WHERE codigo = 'RED001';


-- ────────────────────────────────────────
-- 3) COUNT(DISTINCT coluna) — conta valores ÚNICOS
-- ────────────────────────────────────────
select * from matriculas;
SELECT DISTINCT status FROM matriculas;
SELECT COUNT(*) AS total_matriculas, COUNT(DISTINCT status) AS status_diferentes FROM matriculas;
-- total_matriculas=30, status_diferentes=3  (ativa, trancada, cancelada)

