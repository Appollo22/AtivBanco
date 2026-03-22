create schema faculdade;

use faculdade;

CREATE TABLE alunos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    data_matricula DATE NOT NULL DEFAULT (CURRENT_DATE),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

DESCRIBE alunos;

CREATE TABLE professores (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    titulacao ENUM('graduacao','especializacao','mestrado','doutorado') NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

DESCRIBE professores;

CREATE TABLE disciplinas (
	id INT AUTO_INCREMENT PRIMARY KEY,
	codigo VARCHAR(10) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL,
    ementa TEXT
);

DESCRIBE disciplinas;

CREATE TABLE turmas (
	id INT AUTO_INCREMENT PRIMARY KEY,
    disciplina_id INT NOT NULL,
    professor_id INT NOT NULL,
    semestre VARCHAR(6) NOT NULL,
    horario VARCHAR(50),
    FOREIGN KEY (disciplina_id) REFERENCES disciplinas(id),
    FOREIGN KEY (professor_id) REFERENCES professores(id)
);

DESCRIBE turmas;

CREATE TABLE matriculas (
	id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT NOT NULL,
    turma_id int not null,
    data_matricula date not null default (current_date),
    status enum('ativa','trancada','cancelada') NOT NULL DEFAULT 'ativa',
    FOREIGN KEY (aluno_id) REFERENCES alunos(id),
    FOREIGN KEY (turma_id) REFERENCES turmas(id)
);

DESCRIBE matriculas;

CREATE TABLE notas (
	id int auto_increment primary key,
    matricula_id int not null,
    avaliacao varchar(30) not null,
    nota decimal(4,2) not null check (nota >= 0 and nota <= 10),
    data_lancamento DATE NOT NULL DEFAULT (current_date),
    foreign key (matricula_id) references matriculas(id)
);

DESCRIBE notas;

CREATE TABLE presencas (
	id INT AUTO_INCREMENT PRIMARY KEY,
    matricula_id INT NOT NULL,
    data_aula DATE NOT NULL,
    presente BOOLEAN NOT NULL DEFAULT TRUE,
    foreign key (matricula_id) REFERENCES matriculas(id)
);

DESCRIBE presencas;






