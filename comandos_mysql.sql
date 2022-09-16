#Relatório de departamentos:

SELECT sigla, nome FROM departamento ORDER BY nome;

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Relatório de dependentes:

SELECT colaborador.nome, dependente.nome, dependente.data_nascimento, dependente.parentesco FROM dependente INNER JOIN colaborador
ON dependente.colaborador = colaborador.matricula ORDER BY colaborador.nome and dependente.nome;

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Inserir novo colaborador 

INSERT INTO endereco VALUES ('37410-000', 'MG', 'TRES CORACOES', 'CENTRO', 'RUA PRINCIPAL');

INSERT INTO colaborador VALUES (678, 128247, 'Fulano de Tal', 'email@email.com', 'email@corp.com', '2000', 'DEPTI', '37410-000', 'NENHUM');

INSERT INTO telefone_colaborador VALUES ('(61)9 9999-9999', '678', 'R');

INSERT INTO papel VALUES (8, 'Especialista de Negocios');

INSERT INTO projeto VALUES (5, 'BI', 'A123', '2022-08-01', '2022-08-31');

INSERT INTO atribuicao VALUES (678, 5, 8);

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Deletar departamento e todos os colaboradores daquele departamento

#UPDATE departamento SET chefe = '' WHERE departamento.chefe = (SELECT matricula FROM colaborador WHERE departamento = 'SECAP');
#select * from departamento WHERE departamento.chefe = (SELECT matricula FROM colaborador WHERE departamento = 'SECAP');#

DELETE FROM atribuicao WHERE colaborador = ANY (SELECT matricula FROM colaborador WHERE departamento ='SECAP');

DELETE FROM telefone_colaborador WHERE colaborador = ANY (SELECT matricula FROM colaborador WHERE departamento ='SECAP');

DELETE FROM dependente WHERE colaborador = ANY (SELECT matricula FROM colaborador WHERE departamento ='SECAP');

UPDATE departamento SET chefe ='678' WHERE sigla = 'SECAP';

DELETE FROM colaborador WHERE departamento ='SECAP';
DELETE FROM departamento WHERE sigla ='SECAP';

