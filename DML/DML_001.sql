-- =============================================
-- DML_001.sql — Popular o Schema Acadêmico
-- Aula 3 | Tópicos Avançados de BD | UniSENAI
-- =============================================

USE faculdade;

-- 1. PROFESSORES (5)
INSERT INTO professores (nome, cpf, email, titulacao) VALUES
('Carlos Henrique Silva', '111.111.111-11', 'carlos.silva@uni.edu.br', 'doutorado'),
('Maria Fernanda Costa',  '222.222.222-22', 'maria.costa@uni.edu.br',  'mestrado'),
('Roberto Almeida',       '333.333.333-33', 'roberto.almeida@uni.edu.br', 'doutorado'),
('Ana Paula Oliveira',    '444.444.444-44', 'ana.oliveira@uni.edu.br', 'especializacao'),
('Lucas Martins',         '555.555.555-55', 'lucas.martins@uni.edu.br', 'mestrado');

-- 2. DISCIPLINAS (6)
INSERT INTO disciplinas (codigo, nome, carga_horaria, ementa) VALUES
('BD001',  'Banco de Dados I',      80, 'Modelagem relacional, SQL básico, normalização'),
('BD002',  'Banco de Dados II',     60, 'SQL avançado, views, procedures, triggers'),
('PRG001', 'Programação I',         80, 'Lógica, variáveis, estruturas de controle'),
('PRG002', 'Programação II',        80, 'POO, herança, polimorfismo, coleções'),
('ALG001', 'Algoritmos',            60, 'Ordenação, busca, complexidade'),
('RED001', 'Redes de Computadores', 60, 'TCP/IP, roteamento, protocolos');

-- 3. ALUNOS (15)
INSERT INTO alunos (nome, cpf, email, data_nascimento, data_matricula, ativo) VALUES
('João Pedro Santos',    '100.000.000-01', 'joao.santos@aluno.uni.br',     '2003-03-15', '2025-02-10', TRUE),
('Mariana Lima',         '100.000.000-02', 'mariana.lima@aluno.uni.br',     '2004-07-22', '2025-02-10', TRUE),
('Felipe Rodrigues',     '100.000.000-03', 'felipe.rodrigues@aluno.uni.br', '2003-11-08', '2025-02-10', TRUE),
('Camila Ferreira',      '100.000.000-04', 'camila.ferreira@aluno.uni.br',  '2004-01-30', '2025-02-10', TRUE),
('Rafael Souza',         '100.000.000-05', 'rafael.souza@aluno.uni.br',     '2002-09-12', '2025-02-10', TRUE),
('Beatriz Alves',        '100.000.000-06', 'beatriz.alves@aluno.uni.br',    '2003-05-25', '2025-02-10', TRUE),
('Lucas Oliveira',       '100.000.000-07', 'lucas.oliveira@aluno.uni.br',   '2004-12-03', '2025-02-10', TRUE),
('Isabela Costa',        '100.000.000-08', 'isabela.costa@aluno.uni.br',    '2003-08-17', '2025-02-10', TRUE),
('Thiago Martins',       '100.000.000-09', 'thiago.martins@aluno.uni.br',   '2002-04-05', '2025-02-10', TRUE),
('Larissa Pereira',      '100.000.000-10', 'larissa.pereira@aluno.uni.br',  '2004-06-28', '2025-02-10', TRUE),
('Gabriel Nascimento',   '100.000.000-11', 'gabriel.nasc@aluno.uni.br',     '2003-02-14', '2025-02-10', TRUE),
('Fernanda Ribeiro',     '100.000.000-12', 'fernanda.ribeiro@aluno.uni.br', '2004-10-09', '2025-02-10', TRUE),
('Pedro Henrique Dias',  '100.000.000-13', 'pedro.dias@aluno.uni.br',       '2003-07-20', '2025-02-10', FALSE),
('Julia Mendes',         '100.000.000-14', 'julia.mendes@aluno.uni.br',     '2004-03-11', '2025-02-10', TRUE),
('Matheus Carvalho',     '100.000.000-15', 'matheus.carv@aluno.uni.br',     '2002-12-01', '2025-02-10', TRUE);

-- 4. TURMAS (8)
INSERT INTO turmas (disciplina_id, professor_id, semestre, horario) VALUES
(1, 1, '2025/1', 'SEG 19:00-22:00'),
(2, 1, '2025/1', 'QUA 19:00-22:00'),
(3, 4, '2025/1', 'TER 19:00-22:00'),
(4, 2, '2025/1', 'QUI 19:00-22:00'),
(5, 3, '2025/1', 'SEX 19:00-22:00'),
(6, 5, '2025/1', 'TER 19:00-22:00'),
(1, 3, '2025/1', 'SAB 08:00-11:00'),
(3, 2, '2025/1', 'SAB 08:00-11:00');

-- 5. MATRÍCULAS (30)
INSERT INTO matriculas (aluno_id, turma_id, status) VALUES
(1, 1, 'ativa'), (2, 1, 'ativa'), (3, 1, 'ativa'),
(4, 1, 'ativa'), (5, 1, 'ativa'), (6, 1, 'trancada'),
(1, 2, 'ativa'), (2, 2, 'ativa'), (5, 2, 'ativa'),
(9, 2, 'ativa'), (11, 2, 'cancelada'),
(3, 3, 'ativa'), (7, 3, 'ativa'), (8, 3, 'ativa'),
(10, 3, 'ativa'), (12, 3, 'ativa'),
(1, 4, 'ativa'), (4, 4, 'ativa'), (9, 4, 'ativa'), (14, 4, 'ativa'),
(2, 5, 'ativa'), (5, 5, 'ativa'), (7, 5, 'ativa'), (15, 5, 'ativa'),
(8, 6, 'ativa'), (11, 6, 'ativa'), (14, 6, 'ativa'),
(13, 7, 'ativa'), (15, 7, 'ativa'),
(13, 8, 'ativa');

-- 6. NOTAS
INSERT INTO notas (matricula_id, avaliacao, nota) VALUES
(1, 'P1', 8.50), (1, 'P2', 7.00), (1, 'Trabalho', 9.00),
(2, 'P1', 9.00), (2, 'P2', 9.50), (2, 'Trabalho', 10.00),
(3, 'P1', 5.00), (3, 'P2', 4.50), (3, 'Trabalho', 6.00),
(4, 'P1', 7.00), (4, 'P2', 8.00), (4, 'Trabalho', 7.50),
(5, 'P1', 3.00), (5, 'P2', 2.50), (5, 'Trabalho', 5.00),
(7, 'P1', 7.50), (7, 'P2', 8.00),
(8, 'P1', 6.00), (8, 'P2', 5.50),
(9, 'P1', 9.00), (9, 'P2', 8.50),
(10, 'P1', 4.00), (10, 'P2', 6.00),
(12, 'P1', 8.00), (12, 'P2', 7.50), (12, 'Trabalho', 8.50),
(13, 'P1', 6.50), (13, 'P2', 7.00), (13, 'Trabalho', 7.00),
(14, 'P1', 9.50), (14, 'P2', 9.00), (14, 'Trabalho', 10.00),
(15, 'P1', 5.00), (15, 'P2', 4.00), (15, 'Trabalho', 6.50),
(16, 'P1', 7.00), (16, 'P2', 8.00), (16, 'Trabalho', 7.50),
(17, 'P1', 6.00), (17, 'P2', 7.00),
(18, 'P1', 8.50), (18, 'P2', 9.00),
(19, 'P1', 3.50), (19, 'P2', 4.00),
(20, 'P1', 7.00), (20, 'P2', 7.50),
(21, 'P1', 7.00), (21, 'P2', 6.50),
(22, 'P1', 5.50), (22, 'P2', 6.00),
(23, 'P1', 8.00), (23, 'P2', 8.50),
(24, 'P1', 9.00), (24, 'P2', 9.50);

-- 7. PRESENÇAS
INSERT INTO presencas (matricula_id, data_aula, presente) VALUES
(1, '2025-02-10', TRUE),  (1, '2025-02-17', TRUE),  (1, '2025-02-24', TRUE),
(2, '2025-02-10', TRUE),  (2, '2025-02-17', TRUE),  (2, '2025-02-24', TRUE),
(3, '2025-02-10', TRUE),  (3, '2025-02-17', FALSE), (3, '2025-02-24', TRUE),
(4, '2025-02-10', TRUE),  (4, '2025-02-17', TRUE),  (4, '2025-02-24', FALSE),
(5, '2025-02-10', FALSE), (5, '2025-02-17', FALSE), (5, '2025-02-24', TRUE);

-- VALIDAÇÃO
SELECT 'professores' AS tabela, COUNT(*) AS total FROM professores
UNION ALL SELECT 'disciplinas', COUNT(*) FROM disciplinas
UNION ALL SELECT 'alunos', COUNT(*) FROM alunos
UNION ALL SELECT 'turmas', COUNT(*) FROM turmas
UNION ALL SELECT 'matriculas', COUNT(*) FROM matriculas
UNION ALL SELECT 'notas', COUNT(*) FROM notas
UNION ALL SELECT 'presencas', COUNT(*) FROM presencas;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM presencas;
DELETE FROM notas;
DELETE FROM matriculas;
DELETE FROM turmas;
DELETE FROM professores;
DELETE FROM disciplinas;
DELETE FROM alunos;

ALTER TABLE disciplinas AUTO_INCREMENT = 1;
ALTER TABLE professores AUTO_INCREMENT = 1;
ALTER TABLE alunos AUTO_INCREMENT = 1;

DROP SCHEMA faculdade;
CREATE SCHEMA faculdade;
USE faculdade;