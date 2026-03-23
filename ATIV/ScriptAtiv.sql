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

/* 14. Rode EXPLAIN na query: SELECT * FROM vw_boletim WHERE aluno = 'Mariana Lima'; — O EXPLAIN mostra
a query da view expandida ou não?
*/

explain select * from vw_boletim where aluno = 'Mariana Lima';

-- Sim, esta expandida

/* 15. Escreva uma query que retorne os alunos cuja nota em qualquer avaliação é maior que a média geral de
notas. Use subquery no WHERE.
*/

select a.nome, n.nota, n.avaliacao
from notas as n
join alunos as a on n.matricula_id = a.id
where nota > (select round(avg(nota),2) as media_geral from notas);

/* 16. Escreva uma query que retorne os nomes dos professores que NÃO têm nenhuma turma atribuída. Use NOT
EXISTS.
*/

select nome from professores as p
where not exists(
	select 1
    from turmas as t
    where t.professor_id = p.id
);

/* 17. Usando subquery no FROM (tabela derivada), liste os alunos com média geral abaixo de 6.0.
*/

select a.nome, tabela_medias.media
from (select matricula_id, round(avg(nota),2) as media from notas
	group by matricula_id) as tabela_medias
join alunos as a on tabela_medias.matricula_id = a.id
where tabela_medias.media <6

/* 18. Reescreva o exercício 15 usando JOIN em vez de subquery. Compare os resultados. Rode EXPLAIN em
ambas.
*/

explain SELECT a.nome, N.NOTA, N.AVALIACAO 
FROM ALUNOS AS A
JOIN NOTAS AS N 
ON N.ID = A.ID
WHERE nota > (SELECT AVG(nota) FROM notas);

-- aumentou os rows


/* 19. Escreva uma query que mostre, por turma_id, a quantidade de matrículas com status 'ativa' e a quantidade
total. Use GROUP BY.
*/

select turma_id,
	sum(case when status = 'ativa' then 1 else 0 end) as total_ativas,
    count(*) as total_matriculas
from matriculas
group by turma_id

/* 20. Liste as disciplinas cuja média geral de notas é menor que 7. Use JOIN até disciplinas e HAVING.
*/

SELECT d.nome AS disciplina, AVG(n.nota) AS media_geral
FROM disciplinas d
JOIN turmas t ON d.id = t.disciplina_id
JOIN matriculas m ON t.id = m.turma_id
JOIN notas n ON n.matricula_id = m.id
GROUP BY d.id, d.nome
HAVING AVG(n.nota) < 7;



