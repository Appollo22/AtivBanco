-- ============================================================
-- AULA 3 | HAVING — Filtrar DEPOIS de agrupar
-- Tópicos Avançados de Banco de Dados | UniSENAI 2026/1
-- ============================================================
-- WHERE filtra LINHAS (antes de agrupar).
-- HAVING filtra GRUPOS (depois de agrupar).
-- Ordem: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
-- ============================================================

USE faculdade;

-- conta LINHAS (incluindo NULLs)
SELECT COUNT(*) FROM alunos;

-- conta valores NÃO NULL da coluna email
SELECT COUNT(email) FROM alunos;

-- conta valores DISTINTOS não NULL
SELECT COUNT(DISTINCT turma_id) FROM matriculas;

-- Turmas com mais de 4 matrículas
SELECT turma_id, COUNT(*) AS total
FROM matriculas
GROUP BY turma_id
HAVING COUNT(*) > 4;

-- Alunos em risco: média abaixo de 7
SELECT matricula_id, ROUND(AVG(nota), 2) AS media
FROM notas
GROUP BY matricula_id
HAVING AVG(nota) < 7;

-- Destaques: média >= 9
SELECT matricula_id, ROUND(AVG(nota), 2) AS media
FROM notas
GROUP BY matricula_id
HAVING AVG(nota) >= 9;

-- Avaliações cuja média geral ficou abaixo de 6
SELECT avaliacao, ROUND(AVG(nota), 2) AS media
FROM notas
GROUP BY avaliacao
HAVING AVG(nota) < 6;

-- ⚠️ Erro proposital pra mostrar que WHERE não aceita agregação:
SELECT turma_id, COUNT(*) FROM matriculas WHERE COUNT(*) > 3 GROUP BY turma_id;
-- Resultado: ERROR 1111 - Invalid use of group function
