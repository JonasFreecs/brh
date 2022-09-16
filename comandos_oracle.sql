/*Relatório de departamentos ordenados pelo nome */
SELECT sigla, nome FROM brh.departamento ORDER BY nome;


/*Relatório de dependentes*/
SELECT colaborador.nome, dependente.nome, dependente.data_nascimento, dependente.parentesco FROM brh.dependente INNER JOIN brh.colaborador
ON dependente.colaborador = colaborador.matricula ORDER BY colaborador.nome, dependente.nome;

/*Adicionar novo colaborador no projeto BI com o papel de Especialista de negócios */
INSERT INTO endereco (cep, uf, cidade, bairro, logradouro) VALUES ('37410-000', 'MG', 'TRES CORACOES', 'CENTRO', 'Rua teste');

INSERT INTO brh.colaborador (matricula, cpf,nome, email_pessoal, email_corporativo, salario, departamento, CEP, complemento_endereco) 
VALUES (123, '128.247.576.20', 'Jonas', 'email@email.com', 'email@corp.com', '5000', 'DIR', '37410-000', 'apartamento 45');

INSERT INTO brh.papel (id, nome) VALUES (8, 'Especialista de negócios');

INSERT INTO brh.telefone_colaborador (numero, colaborador, tipo) VALUES ('(61)99999-9999', 123, 'R');

INSERT INTO brh.projeto (id, nome, responsavel, inicio, fim) VALUES (9, 'BI', 123, '01/01/2022', '01/01/2025');

INSERT INTO brh.atribuicao (colaborador, projeto, papel) VALUES (123, 9, 8);


/*Remover departamento SECAP, dispensando todos os funcionarios do departamento */
DELETE FROM brh.atribuicao WHERE colaborador = ANY (SELECT matricula FROM brh.colaborador WHERE departamento ='SECAP');

DELETE FROM brh.telefone_colaborador WHERE colaborador = ANY (SELECT matricula FROM brh.colaborador WHERE departamento ='SECAP');

DELETE FROM brh.dependente WHERE colaborador = ANY (SELECT matricula FROM brh.colaborador WHERE departamento ='SECAP');

UPDATE brh.departamento SET chefe = 'G123' WHERE sigla = 'SECAP';

DELETE FROM brh.colaborador WHERE departamento = 'SECAP';

DELETE FROM brh.departamento WHERE sigla = 'SECAP';

/* Relatório de contatos */
SELECT colaborador.nome, colaborador.email_corporativo, telefone_colaborador.numero
FROM brh.colaborador INNER JOIN brh.telefone_colaborador ON colaborador.matricula = telefone_colaborador.colaborador;

/*Relatório analítico de equipes 

1. O nome do Departamento;
1. O nome do chefe do Departamento;
1. O nome do Colaborador;
1. O nome do Projeto que ele está alocado;
1. O nome do papel desempenhado por ele;
1. O número de telefone do Colaborador;
1. O nome do Dependente do Colaborador.
*/

SELECT departamento.nome, chefe_departamento.nome, colab.nome , colaborador_projeto.nome,  fds.nome, telefone_colaborador.numero, dependente.nome
FROM brh.departamento INNER JOIN brh.colaborador chefe_departamento ON departamento.chefe = chefe_departamento.matricula
INNER JOIN brh.colaborador colab ON colab.matricula = chefe_departamento.matricula 
INNER JOIN brh.atribuicao papel_exercido ON papel_exercido.colaborador = colab.matricula 
INNER JOIN brh.papel fds ON papel_exercido.papel = fds.id
INNER JOIN brh.projeto colaborador_projeto ON colaborador_projeto.id = papel_exercido.projeto
INNER JOIN brh.telefone_colaborador ON telefone_colaborador.colaborador = colab.matricula
INNER JOIN brh.dependente ON dependente.colaborador = telefone_colaborador.colaborador;

/*---------------------------------OK------------------------------------------------------------*/
