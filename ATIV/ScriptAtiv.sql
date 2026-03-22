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

select aluno, disciplina, avg(nota) as media from vw_boletim
group by aluno, disciplina