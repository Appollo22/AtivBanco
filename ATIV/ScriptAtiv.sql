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
