/* 1. Liste todos os nomes de alunos e professores numa única coluna, com uma coluna extra indicando 'ALUNO' ou
'PROFESSOR'. Use UNION ALL.
*/

select nome, 'Aluno' as classificacao from alunos
union all
select nome, 'Professor' as classificacao from professores

/* 2. Reescreva o exercício 1 usando UNION (sem ALL). O resultado muda? Explique por quê no comentário SQL.
*/

select nome, 'Aluno' as classificacao from alunos
union
select nome, 'Professor' as classificacao from professores

/* Não muda nada devido a todos os nomes serem diferentes */

/* 3. Monte uma query que retorne os nomes das avaliações distintas que existem na tabela notas. Faça de duas
formas: com DISTINCT e com UNION.
*/

select distinct avaliacao from notas

select avaliacao, 'Avalicao' as tipo from notas
union
select avaliacao, 'Avalicao' as tipo from notas

/* 4. Crie uma VIEW chamada vw_boletim que mostre: nome do aluno, nome da disciplina, avaliação e nota. Use
os JOINs necessários (notas → matriculas → alunos, matriculas → turmas → disciplinas).
*/

create view vw_boletim as
select a.nome as aluno, d.nome as disciplina, n.avaliacao, n.nota, t.semestre
from notas n
join matriculas m on m.id = n.matricula_id
join alunos a on a.id = m.aluno_id
join turmas t on t.id = m.turma_id
join disciplinas d on d.id = t.disciplina_id; 

/* 5. Usando a vw_boletim, escreva uma query que retorne a média de cada aluno por disciplina.
*/

select aluno, disciplina, round(avg(nota), 2) as media from vw_boletim
group by aluno, disciplina

/* 6. Crie uma VIEW chamada vw_alunos_seguros que mostre apenas id e nome dos alunos (escondendo CPF,
email, data_nascimento).
*/

create view vw_alunos_seguros as 
select id, nome from alunos

/* 7. Crie um usuário 'relatorio'@'localhost' com senha 'rel123'. Dê permissão de SELECT apenas na view
vw_boletim. Depois rode SHOW GRANTS pra confirmar.
*/

create user 'relatorio@localhost' identified by 'rel123';
grant select on vw_boletim to 'relatorio@localhost'

/* 8. Revogue todas as permissões do usuário 'relatorio' e depois exclua o usuário.
*/

revoke all privileges on vw_boletim from 'relatorio@localhost';
drop user 'relatorio@localhost';

/* 9. Crie um índice simples na coluna nome da tabela professores.
*/

create index ind_nome_professor on professores(nome)

show index from professores

/* 10. Crie um índice composto na tabela notas nas colunas (matricula_id, avaliacao). Depois rode SHOW INDEX
FROM notas pra confirmar.
*/

create index ind_id_avaliacao on notas(matricula_id, avaliacao)

show index from notas

/* 11. Liste todos os índices da tabela alunos e identifique quais foram criados automaticamente pelas constraints
UNIQUE.
*/

show index from alunos

-- cpf e e-mail sao automaticas pela unique

/* 12. Rode EXPLAIN em: SELECT * FROM alunos WHERE cpf = '100.000.000-01'; — Anote type, rows e key. O
UNIQUE do CPF foi usado?
*/

explain select * from alunos where cpf = '100.000.000-01';

-- type const
-- key cpf
-- rows 1
-- só 1 linha entáo foi usado o UNIQUE

/* 13. Rode EXPLAIN em: SELECT * FROM notas WHERE avaliacao = 'P1'; — Crie um índice na coluna avaliacao e
rode EXPLAIN de novo. O que mudou em type e rows?
*/

explain select * from notas where avaliacao = 'P1'

create index ind_avaliacao on notas(avaliacao)

-- type ficou como ref e o numero de rows diminuiu 





