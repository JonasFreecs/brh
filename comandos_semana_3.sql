-- Filtrar dependentes:

SELECT c.nome as nome_colaborador, d.nome as nome_dependente, d.data_nascimento, d.parentesco FROM brh.dependente d
INNER JOIN brh.colaborador c
ON d.colaborador = c.matricula
WHERE TO_CHAR(d.data_nascimento, 'MM') IN (04, 05, 06)
OR d.nome LIKE '%h%'
ORDER BY c.nome, d.nome;



--Colaborador com maior salário:

SELECT nome, salario AS maior_salario FROM brh.colaborador
WHERE salario = (SELECT MAX(salario) FROM brh.colaborador);


--Relatório de senioridade:

SELECT matricula, nome, salario, 
    (CASE WHEN salario <= 3000 THEN 'Junior'
        WHEN salario > 3000 AND salario <= 6000 THEN 'Pleno'
        WHEN salario > 6000 AND salario <= 20000 THEN 'Senior'
        ELSE 'Corpo diretor'
    END) AS Senioridade 
FROM brh.colaborador order by salario;


--Listar faixa etária dos dependentes:

SELECT d.*, nvl(floor((months_between(sysdate, data_nascimento) / 12)), 0) idade,
        CASE 
        WHEN nvl(floor((months_between(sysdate, data_nascimento) / 12)), 0) < 18
        THEN 'Menor de idade'
        ELSE 'Maior de idade'
    END faixa_etaria
    FROM brh.dependente d
    ORDER BY colaborador, nome;


--Ajustar id do projeto caso esteja com id errado:

UPDATE brh.projeto
   SET id = id - 4
 WHERE nome != 'BI';



--Listar quantidade de colaboradores em cada projeto, ordenado por departamento

SELECT d.nome nome_departamento, p.nome nome_projeto, COUNT(c.matricula) AS quantidade_funcionarios FROM brh.departamento d
INNER JOIN brh.colaborador c ON d.sigla = c.departamento
INNER JOIN brh.atribuicao a ON c.matricula = a.colaborador
INNER JOIN brh.projeto p ON a.projeto = p.id
GROUP BY d.nome, p.nome;


--Listar colaboradores com mais dependentes

SELECT c.nome, count(d.colaborador) as quantidade_filhos FROM brh.dependente d 
INNER JOIN brh.colaborador c ON d.colaborador = c.matricula
GROUP BY c.nome
ORDER BY count(d.colaborador) DESC;


--Listar dependentes por faixa etária:

SELECT d.*, nvl(floor((months_between(sysdate, data_nascimento) / 12)), 0) idade,
        CASE 
        WHEN nvl(floor((months_between(sysdate, data_nascimento) / 12)), 0) < 18
        THEN 'Menor de idade'
        ELSE 'Maior de idade'
    END faixa_etaria
    FROM brh.dependente d
    ORDER BY colaborador, nome;



