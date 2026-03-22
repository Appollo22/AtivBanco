-- ════════════════════════════════════════
-- FUNÇÕES DE AGREGAÇÃO (antes do GROUP BY)
-- ════════════════════════════════════════

-- Quantas notas existem no total?
select * from notas;
SELECT COUNT(*) AS total_notas FROM notas;

-- Qual a média geral de todas as notas?
select * from notas;
SELECT AVG(nota) AS media_crua FROM notas;

-- Mesma média, mas arredondada (2 casas):
SELECT ROUND(AVG(nota), 2) AS media FROM notas;
SELECT ROUND(AVG(nota),2) FROM NOTAS;

SELECT ROUND(SUM(NOTA) / COUNT(NOTA),2) FROM NOTAS;
SELECT AVG(NOTA) FROM NOTAS;

-- Qual a maior nota lançada?
SELECT MAX(nota) AS maior FROM notas;

-- Qual a menor nota lançada?
SELECT MIN(nota) AS menor FROM notas;

-- Soma de todas as notas (menos útil, mas existe):
SELECT SUM(nota) AS soma_total FROM notas;

-- Tudo junto numa query só:
SELECT 
    COUNT(*)             AS total,
    ROUND(AVG(nota), 2)  AS media,
    MIN(nota)            AS menor,
    MAX(nota)            AS maior,
    ROUND(SUM(nota), 2)  AS soma
FROM notas;