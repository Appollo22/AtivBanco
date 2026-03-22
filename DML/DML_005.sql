-- ════════════════════════════════════════
-- GROUP BY — Agrupar e Calcular
-- ════════════════════════════════════════

-- Até agora, todas as funções calcularam sobre a tabela INTEIRA.
-- Um número só. Mas e se eu quiser a média de CADA aluno?

-- Primeiro, olha as notas cruas:
select * from notas;
SELECT matricula_id, avaliacao, nota
FROM notas
WHERE matricula_id IN (1, 2, 3)
ORDER BY matricula_id;
-- 9 linhas: matrícula 1 tem 3 notas, matrícula 2 tem 3, matrícula 3 tem 3

-- Agora agrupa: cada matrícula vira UMA linha
SELECT matricula_id, ROUND(AVG(nota), 2) AS media
FROM notas
WHERE matricula_id IN (1, 2, 3)
GROUP BY matricula_id;

-- Quantos alunos por status de matrícula?
select * from matriculas;
SELECT status, COUNT(*) AS total
FROM matriculas
GROUP BY status;

-- Média de nota por tipo de avaliação:
select * from notas;
SELECT avaliacao, ROUND(AVG(nota), 2) AS media
FROM notas
GROUP BY avaliacao;

-- Quantas matrículas cada turma tem?
SELECT turma_id, COUNT(*) AS total_matriculas
FROM matriculas
GROUP BY turma_id
ORDER BY total_matriculas DESC;

-- GROUP BY com 1 campo: agrupa só por turma
select * from matriculas;
SELECT turma_id, COUNT(*) AS total
FROM matriculas
GROUP BY turma_id;

-- GROUP BY com 2 campos: agrupa por turma E status
SELECT turma_id, status, COUNT(*) AS total
FROM matriculas
GROUP BY turma_id, status;

-- Primeiro, vê todas as turmas com suas contagens:
SELECT turma_id, COUNT(*) AS total
FROM matriculas
GROUP BY turma_id;

-- Agora, só quero turmas com MAIS de 4 matrículas:
SELECT turma_id, COUNT(*) AS total
FROM matriculas
GROUP BY turma_id
HAVING COUNT(*) > 4;