/* 1. Liste todos os nomes de alunos e professores numa única coluna, com uma coluna extra indicando 'ALUNO' ou
'PROFESSOR'. Use UNION ALL.
*/

select nome, 'Aluno' as classificacao from alunos
union all
select nome, 'Professor' as classificacao from professores