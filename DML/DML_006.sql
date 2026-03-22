-- ════════════════════════════════════════
-- COMMENT — Documentação no Banco
-- ════════════════════════════════════════
-- Quem abre o banco pela primeira vez precisa entender
-- o que cada tabela e coluna significa.
-- COMMENT = contrato técnico que acompanha o banco, não o código.

-- ────────────────────────────────────────
-- 1) Comentário na TABELA
-- ────────────────────────────────────────

ALTER TABLE alunos COMMENT = 'Cadastro de alunos. CPF e email sao unicos.';
ALTER TABLE alunos COMMENT = '';
ALTER TABLE notas COMMENT = 'Notas por avaliacao. Vinculada a matricula.';

-- Consultar comentários de todas as tabelas:
SELECT TABLE_NAME, TABLE_COMMENT
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'faculdade';
-- Repara: só alunos e notas têm COMMENT. As outras tão vazias.

-- ────────────────────────────────────────
-- 2) Comentário na COLUNA
-- ────────────────────────────────────────
-- ⚠️ MODIFY redefine a coluna inteira. Precisa repetir tipo, NOT NULL, DEFAULT.
ALTER TABLE alunos MODIFY ativo BOOLEAN NOT NULL DEFAULT TRUE
COMMENT 'FALSE = aluno desligado ou transferido';

ALTER TABLE alunos MODIFY ativo BOOLEAN NOT NULL DEFAULT TRUE
COMMENT '';

ALTER TABLE matriculas MODIFY status ENUM('ativa','trancada','cancelada') NOT NULL DEFAULT 'ativa'
COMMENT 'ativa = cursando | trancada = pausou | cancelada = desistiu';

-- Ver os comentários das colunas:
SHOW FULL COLUMNS FROM alunos;
-- Olha a coluna Comment no Result Grid. Ali aparece o texto.

SHOW FULL COLUMNS FROM matriculas;
-- Repara no status: agora tem a explicação de cada valor.
