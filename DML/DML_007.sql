-- ============================================================
-- TÓPICOS AVANÇADOS DE BD — Aula 4
-- UNION · VIEW · DCL · Índices · UNIQUE · EXPLAIN · Subconsultas
-- Schema: faculdade | SGBD: MySQL/MariaDB (Workbench)
-- ============================================================

USE faculdade;


-- ============================================================
-- PARTE 1 — UNION ALL e UNION
-- ============================================================

-- 1.1 Primeiro, veja cada SELECT separado:
SELECT nome, 'ALUNO' AS tipo FROM alunos;

SELECT nome, 'PROFESSOR' AS tipo FROM professores;

-- Dois resultados separados. E se eu quiser tudo numa lista só?

-- 1.2 UNION ALL — junta os dois, mantém tudo
SELECT nome, 'ALUNO' AS tipo FROM alunos
UNION ALL
SELECT nome, 'PROFESSOR' AS tipo FROM professores;

-- Conte as linhas: 15 alunos + 5 professores = 20 linhas.

-- 1.3 UNION — junta e elimina duplicatas
SELECT nome, 'ALUNO' AS tipo FROM alunos
UNION
SELECT nome, 'PROFESSOR' AS tipo FROM professores;

-- Mesmo resultado aqui porque não tem nomes iguais.
-- Mas o banco COMPAROU todas as linhas pra ter certeza. Custo extra.

-- 1.4 Pra ver a diferença real, vamos forçar duplicata:
SELECT 'Maria' AS nome
UNION ALL
SELECT 'Maria' AS nome;
-- 2 linhas (manteve)

SELECT 'Maria' AS nome
UNION
SELECT 'Maria' AS nome;
-- 1 linha (eliminou)

-- 1.5 Exemplo prático: juntar notas de P1 e P2
-- Primeiro P1 sozinho:
SELECT a.nome, d.nome AS disciplina, n.nota, n.avaliacao FROM notas n JOIN matriculas m ON m.id = n.matricula_id JOIN alunos a ON a.id = m.aluno_id JOIN turmas t ON t.id = m.turma_id JOIN disciplinas d ON d.id = t.disciplina_id WHERE n.avaliacao = 'P1';

-- Agora P2 sozinho:
SELECT a.nome, d.nome AS disciplina, n.nota, n.avaliacao FROM notas n JOIN matriculas m ON m.id = n.matricula_id JOIN alunos a ON a.id = m.aluno_id JOIN turmas t ON t.id = m.turma_id JOIN disciplinas d ON d.id = t.disciplina_id WHERE n.avaliacao = 'P2';

-- Agora junta com UNION ALL:
SELECT a.nome, d.nome AS disciplina, n.nota, n.avaliacao FROM notas n JOIN matriculas m ON m.id = n.matricula_id JOIN alunos a ON a.id = m.aluno_id JOIN turmas t ON t.id = m.turma_id JOIN disciplinas d ON d.id = t.disciplina_id WHERE n.avaliacao = 'P1'
UNION ALL
SELECT a.nome, d.nome AS disciplina, n.nota, n.avaliacao FROM notas n JOIN matriculas m ON m.id = n.matricula_id JOIN alunos a ON a.id = m.aluno_id JOIN turmas t ON t.id = m.turma_id JOIN disciplinas d ON d.id = t.disciplina_id WHERE n.avaliacao = 'P2'
ORDER BY nome, disciplina, avaliacao;

SELECT a.nome FROM notas n JOIN matriculas m ON m.id = n.matricula_id JOIN alunos a ON a.id = m.aluno_id JOIN turmas t ON t.id = m.turma_id JOIN disciplinas d ON d.id = t.disciplina_id WHERE n.avaliacao = 'P1'
UNION
SELECT a.nome FROM notas n JOIN matriculas m ON m.id = n.matricula_id JOIN alunos a ON a.id = m.aluno_id JOIN turmas t ON t.id = m.turma_id JOIN disciplinas d ON d.id = t.disciplina_id WHERE n.avaliacao = 'P2'
ORDER BY nome;

-- ============================================================
-- PARTE 2 — VIEW + DCL (casam: VIEW esconde, DCL controla acesso)
-- ============================================================

-- 2.1 Essa query é útil e usamos sempre:
SELECT a.nome AS aluno, d.nome AS disciplina, n.avaliacao, n.nota, t.semestre
FROM notas n
JOIN matriculas m ON m.id = n.matricula_id
JOIN alunos a ON a.id = m.aluno_id
JOIN turmas t ON t.id = m.turma_id
JOIN disciplinas d ON d.id = t.disciplina_id;

-- Funciona, mas ter que escrever isso toda vez é ruim. Solução: VIEW.

-- 2.2 Criando a view:
CREATE OR REPLACE VIEW vw_notas_completas AS
SELECT a.nome AS aluno, d.nome AS disciplina, n.avaliacao, n.nota, t.semestre
FROM notas n
JOIN matriculas m ON m.id = n.matricula_id
JOIN alunos a ON a.id = m.aluno_id
JOIN turmas t ON t.id = m.turma_id
JOIN disciplinas d ON d.id = t.disciplina_id;

-- 2.3 Agora uso como se fosse tabela:
SELECT * FROM vw_notas_completas;

-- Filtrar:
SELECT * FROM vw_notas_completas WHERE avaliacao = 'P1' ORDER BY aluno;

-- Agregar:
SELECT aluno, disciplina, ROUND(AVG(nota), 2) AS media FROM vw_notas_completas GROUP BY aluno, disciplina;

-- A VIEW não guarda dados. Toda vez que consulta, roda a query interna.

-- 2.4 View como camada de segurança
-- Tabela alunos tem CPF, email, data_nascimento...
SELECT * FROM alunos;

-- Mas eu quero que um sistema externo só veja id e nome:
CREATE OR REPLACE VIEW vw_alunos_publico AS
SELECT id, nome FROM alunos;

SELECT * FROM vw_alunos_publico;
-- Escondeu tudo que é sensível.

-- 2.5 View em cima de UNION
CREATE OR REPLACE VIEW vw_pessoas_sistema AS
SELECT nome, 'ALUNO' AS tipo FROM alunos
UNION ALL
SELECT nome, 'PROFESSOR' AS tipo FROM professores;

SELECT * FROM vw_pessoas_sistema ORDER BY tipo, nome;

-- ─── DCL: quem pode acessar essas views? ───

-- 2.6 Criar um usuário:
CREATE USER 'app_leitura'@'localhost' IDENTIFIED BY 'senha123';
select * from alunos;

-- Sem permissão, ele não consegue nada. Vamos dar SELECT em tudo:
GRANT SELECT ON faculdade.* TO 'app_leitura'@'localhost';

-- Ver o que ele pode:
SHOW GRANTS FOR 'app_leitura'@'localhost';

-- 2.7 Permissão granular — outro usuário:
CREATE USER 'app_secretaria'@'localhost' IDENTIFIED BY 'senha456';

-- Secretaria pode ler, inserir e atualizar matrículas:
GRANT SELECT, INSERT, UPDATE ON faculdade.matriculas TO 'app_secretaria'@'localhost';
-- Não pode DELETE. Não pode mexer em estrutura.

SHOW GRANTS FOR 'app_secretaria'@'localhost';

-- 2.8 VIEW + DCL = segurança em camadas
-- Lembra da vw_alunos_publico? Dá acesso SÓ na view:
GRANT SELECT ON faculdade.vw_alunos_publico TO 'app_leitura'@'localhost';
-- O usuário consulta a view e nunca vê CPF, email, data_nascimento.
-- Esse é o padrão real de produção.

-- 2.9 Revogar permissão:
REVOKE SELECT ON faculdade.* FROM 'app_leitura'@'localhost';
SHOW GRANTS FOR 'app_leitura'@'localhost';
-- Agora só tem acesso à view, não mais ao schema inteiro.

-- 2.10 Limpeza:
DROP USER 'app_leitura'@'localhost';
DROP USER 'app_secretaria'@'localhost';

-- PONTO-CHAVE: GRANT ALL PRIVILEGES é perigoso.
-- Em produção, aplicação NUNCA roda como root.
-- Cada sistema tem seu usuário com o mínimo necessário.


-- ============================================================
-- PARTE 3 — ÍNDICES + UNIQUE + EXPLAIN (casam: cria índice, EXPLAIN mostra efeito)
-- ============================================================

-- 3.1 Buscar um aluno pelo nome:
SELECT * FROM alunos WHERE nome = 'Mariana Lima';
-- Funcionou. Mas COMO o banco fez isso?

-- 3.2 EXPLAIN mostra o plano de execução:
EXPLAIN SELECT * FROM alunos WHERE nome = 'Mariana Lima';
-- type=ALL → full table scan. Leu as 15 linhas pra achar 1.
-- key=NULL → não usou nenhum índice.

-- 3.3 Criar um índice:
CREATE INDEX idx_alunos_nome ON alunos(nome);

-- 3.4 EXPLAIN de novo — mesma query:
EXPLAIN SELECT * FROM alunos WHERE nome = 'Mariana Lima';
-- type=ref → usou índice. rows=1 → foi direto.
-- key=idx_alunos_nome → esse é o índice que usou.

-- Resumo do que mudou:
-- type:  ALL → ref
-- rows:  15 → 1
-- key:   NULL → idx_alunos_nome
DROP INDEX idx_alunos_nome ON alunos;
-- 3.5 UNIQUE — índice + restrição de duplicata
-- Na DDL, CPF já foi criado com UNIQUE. Veja:
SHOW INDEX FROM alunos;
-- cpf tem índice UNIQUE automático.

-- Tente duplicar:
-- INSERT INTO alunos (nome, cpf, email, data_nascimento) VALUES ('Teste', '100.000.000-01', 'x@x.com', '2000-01-01');
-- ERRO! Duplicate entry.
-- UNIQUE faz duas coisas: acelera busca + garante integridade.

-- 3.6 Índice composto — mais de uma coluna
-- Primeiro, veja o EXPLAIN sem índice composto:
EXPLAIN SELECT * FROM notas WHERE matricula_id = 5 AND avaliacao = 'P1';

-- Cria o índice composto:
CREATE INDEX idx_notas_matric_aval ON notas(matricula_id, avaliacao);

-- EXPLAIN de novo:
EXPLAIN SELECT * FROM notas WHERE matricula_id = 5 AND avaliacao = 'P1';
-- Compara: type e rows mudaram?

-- 3.7 Ordem importa no índice composto!
-- Índice: (matricula_id, avaliacao)

-- Usa coluna da esquerda → SIM:
EXPLAIN SELECT * FROM notas WHERE matricula_id = 5;

-- Pula a esquerda, usa só a direita → NÃO:
EXPLAIN SELECT * FROM notas WHERE avaliacao = 'P1';

-- 3.8 EXPLAIN em query com JOIN:
EXPLAIN SELECT a.nome, n.nota FROM notas n JOIN matriculas m ON m.id = n.matricula_id JOIN alunos a ON a.id = m.aluno_id WHERE a.nome = 'Mariana Lima';
-- Mostra o plano pra CADA tabela envolvida no JOIN.

-- 3.9 EXPLAIN na VIEW — view não é mágica:
EXPLAIN SELECT * FROM vw_notas_completas WHERE aluno = 'Mariana Lima';
-- O plano mostra a query expandida. View NÃO otimiza.

-- 3.10 Trade-off:
-- Índice acelera leitura, mas cada INSERT/UPDATE/DELETE atualiza o índice.
-- Não crie em tudo. Crie onde tem consulta frequente.

-- 3.11 Listando índices:
SHOW INDEX FROM alunos;
SHOW INDEX FROM notas;

-- Removendo (se quiser):
-- DROP INDEX idx_alunos_nome ON alunos;

-- 3.12 EXPLAIN FORMAT=JSON (opcional, mais detalhes):
EXPLAIN FORMAT=JSON SELECT * FROM notas WHERE matricula_id = 5 AND avaliacao = 'P1';

-- Colunas-chave do EXPLAIN:
-- type:   ALL = full scan (ruim) | ref = índice (bom) | const = direto (ótimo)
-- rows:   quantas linhas o banco ESTIMA ler. Quanto menor, melhor.
-- key:    nome do índice usado (ou NULL = nenhum)
-- Extra:  "Using index" = covering index (ótimo)


-- ============================================================
-- PARTE 4 — SUBCONSULTAS (Subqueries)
-- ============================================================

-- 4.1 Primeiro, qual a média geral?
SELECT ROUND(AVG(nota), 2) AS media_geral FROM notas;
-- Guarde esse número.

-- Agora, quem tirou acima dessa média?
SELECT a.nome, n.nota
FROM notas n
JOIN matriculas m ON m.id = n.matricula_id
JOIN alunos a ON a.id = m.aluno_id
WHERE n.nota > (SELECT AVG(nota) FROM notas);
-- O SELECT interno calcula a média. O externo filtra com esse valor.

-- 4.2 Subquery com IN
-- Primeiro, quais aluno_ids estão em turmas de 2025/1?
SELECT m.aluno_id FROM matriculas m JOIN turmas t ON t.id = m.turma_id WHERE t.semestre = '2025/1';

-- Agora, quais alunos são esses?
SELECT nome FROM alunos
WHERE id IN (
    SELECT m.aluno_id FROM matriculas m
    JOIN turmas t ON t.id = m.turma_id
    WHERE t.semestre = '2025/1'
);

-- 4.3 Subquery no FROM — tabela derivada
-- Primeiro, média por aluno:
SELECT a.nome, ROUND(AVG(n.nota), 2) AS media
FROM notas n
JOIN matriculas m ON m.id = n.matricula_id
JOIN alunos a ON a.id = m.aluno_id
GROUP BY a.nome;

-- Agora, só quem tá abaixo de 7:
SELECT sub.nome, sub.media
FROM (
    SELECT a.nome, ROUND(AVG(n.nota), 2) AS media
    FROM notas n
    JOIN matriculas m ON m.id = n.matricula_id
    JOIN alunos a ON a.id = m.aluno_id
    GROUP BY a.nome
) AS sub
WHERE sub.media < 7;
-- O SELECT interno vira tabela temporária. Alias (AS sub) é obrigatório.

-- 4.4 EXISTS
-- Primeiro, todos os professores:
SELECT nome FROM professores;

-- Quais TÊM turma atribuída?
SELECT p.nome FROM professores p
WHERE EXISTS (
    SELECT 1 FROM turmas t WHERE t.professor_id = p.id
);
-- EXISTS retorna TRUE/FALSE. Para no primeiro match (eficiente).

-- 4.5 Subquery no SELECT — coluna calculada
SELECT a.nome,
    (SELECT ROUND(AVG(n.nota), 2)
     FROM notas n
     JOIN matriculas m ON m.id = n.matricula_id
     WHERE m.aluno_id = a.id) AS media
FROM alunos a;
-- Cuidado: roda UMA VEZ PRA CADA LINHA. Com muitos alunos, fica lento.

-- 4.6 Subquery vs JOIN — mesmo resultado
-- Com subquery:
SELECT nome FROM alunos WHERE id IN (SELECT aluno_id FROM matriculas WHERE status = 'ativa');

-- Com JOIN:
SELECT DISTINCT a.nome FROM alunos a JOIN matriculas m ON m.aluno_id = a.id WHERE m.status = 'ativa';

-- Qual é melhor? EXPLAIN mostra:
EXPLAIN SELECT nome FROM alunos WHERE id IN (SELECT aluno_id FROM matriculas WHERE status = 'ativa');

EXPLAIN SELECT DISTINCT a.nome FROM alunos a JOIN matriculas m ON m.aluno_id = a.id WHERE m.status = 'ativa';
-- Compara type e rows. Esse é o jeito certo de decidir.


-- ============================================================
-- RESUMO
-- ============================================================
-- 
-- UNION ALL  → junta resultados, mantém duplicatas, mais rápido
-- UNION      → junta resultados, elimina duplicatas, mais lento
-- VIEW       → query salva como tabela virtual, não armazena dados
-- DCL        → GRANT dá permissão, REVOKE tira. Privilégio mínimo.
-- INDEX      → acelera leitura, custa em escrita
-- UNIQUE     → índice + restrição de duplicata
-- EXPLAIN    → mostra como o banco executa (type, rows, key)
-- SUBQUERY   → SELECT dentro de SELECT (WHERE, FROM, SELECT, EXISTS)
-- ============================================================