--Função finaliza projeto:


CREATE OR REPLACE FUNCTION brh.finaliza_projeto
    (f_id NUMBER)
    RETURN DATE
IS
    f_check_data_vazia DATE;
    f_data_fim DATE;
    e_projeto_ja_finalizado EXCEPTION;
    e_projeto_nao_cadastrado EXCEPTION;
BEGIN
    SELECT projeto.fim INTO f_check_data_vazia FROM brh.projeto WHERE projeto.id = f_id;
    IF f_check_data_vazia IS NULL THEN
        UPDATE brh.projeto SET projeto.fim = to_date(sysdate, 'DD/MM/YYYY') where id = f_id;
        IF SQL%NOTFOUND THEN
            RAISE e_projeto_nao_cadastrado;
        END IF;
        SELECT projeto.fim INTO f_data_fim FROM brh.projeto WHERE projeto.id = f_id;
        RETURN f_data_fim;
    ELSE 
        RAISE e_projeto_ja_finalizado;
    END IF;
EXCEPTION
    WHEN e_projeto_ja_finalizado THEN
        raise_application_error(-20100, 'Projeto já finalizado');
    WHEN e_projeto_nao_cadastrado THEN
        raise_application_error(-20101, 'Projeto não cadastrado');
END;


--Código de exemplo para teste da função:

SET SERVEROUTPUT ON;

DECLARE
    f_id DATE;
BEGIN
    f_id := brh.finaliza_projeto(1);
    dbms_output.put_line('Projeto finalizado, data da finalização: ' || f_id);
END;


--Validar nome do projeto:

CREATE OR REPLACE PROCEDURE     brh.cria_projeto
    (p_nome brh.projeto.nome%type, p_responsavel brh.projeto.responsavel%type)
IS
    e_nome_curto EXCEPTION;
BEGIN
    IF LENGTH(p_nome) < 2 OR p_nome IS NULL THEN
        RAISE e_nome_curto;
    END IF;
        INSERT INTO brh.projeto(nome, responsavel, inicio) VALUES (p_nome, p_responsavel, to_date(sysdate, 'DD/MM/YYYY'));
        
EXCEPTION
    WHEN e_nome_curto THEN
        raise_application_error(-20100, 'O nome do projeto não pode ser vazio e deve ter dois ou mais caracteres');

END;


--Validar data de nascimento:

CREATE OR REPLACE FUNCTION brh.calcula_idade
    (f_data_nascimento IN varchar2)
    RETURN NUMBER
IS
    f_idade NUMBER;
    e_data_invalida EXCEPTION;
BEGIN
    IF to_date(f_data_nascimento, 'DD/MM/YYYY') > to_date(sysdate, 'DD/MM/YYYY') OR to_date(f_data_nascimento, 'DD/MM/YYYY') IS NULL THEN
        RAISE e_data_invalida;
    END IF;
    SELECT  FLOOR(MONTHS_BETWEEN(sysdate, (to_date(f_data_nascimento, 'DD/MM/YYYY')))/12) INTO f_idade FROM DUAL;
    RETURN f_idade;

EXCEPTION
    WHEN e_data_invalida THEN
        raise_application_error(-20100, 'Impossível calcular idade! Data inválida' || f_data_nascimento);
END;



--Package e package body das funções e procedures criadas


CREATE OR REPLACE PACKAGE brh.pkg_projeto
IS
PROCEDURE cria_projeto
    (p_nome brh.projeto.nome%type,
     p_responsavel brh.projeto.responsavel%type);

FUNCTION calcula_idade
    (f_data_nascimento IN varchar2)
    RETURN NUMBER;

FUNCTION finaliza_projeto
    (f_id NUMBER)
    RETURN DATE;

END;


CREATE OR REPLACE PACKAGE BODY brh.pkg_projeto
IS

PROCEDURE cria_projeto
    (p_nome brh.projeto.nome%type, p_responsavel brh.projeto.responsavel%type)
IS
    e_nome_curto EXCEPTION;
BEGIN
    IF LENGTH(p_nome) < 2 OR p_nome IS NULL THEN
        RAISE e_nome_curto;
    END IF;
        INSERT INTO brh.projeto(nome, responsavel, inicio) VALUES (p_nome, p_responsavel, to_date(sysdate, 'DD/MM/YYYY'));

EXCEPTION
    WHEN e_nome_curto THEN
        raise_application_error(-20100, 'O nome do projeto não pode ser vazio e deve ter dois ou mais caracteres');

END;

FUNCTION calcula_idade
    (f_data_nascimento IN varchar2)
    RETURN NUMBER
IS
    f_idade NUMBER;
    e_data_invalida EXCEPTION;
BEGIN
    IF to_date(f_data_nascimento, 'DD/MM/YYYY') > to_date(sysdate, 'DD/MM/YYYY') OR to_date(f_data_nascimento, 'DD/MM/YYYY') IS NULL THEN
        RAISE e_data_invalida;
    END IF;
    SELECT  FLOOR(MONTHS_BETWEEN(sysdate, (to_date(f_data_nascimento, 'DD/MM/YYYY')))/12) INTO f_idade FROM DUAL;
    RETURN f_idade;

EXCEPTION
    WHEN e_data_invalida THEN
        raise_application_error(-20100, 'Impossível calcular idade! Data inválida' || f_data_nascimento);
END;

FUNCTION finaliza_projeto
    (f_id NUMBER)
    RETURN DATE
IS
    f_checa_id NUMBER;
    f_check_data_vazia DATE;
    f_data_fim DATE;
    e_projeto_ja_finalizado EXCEPTION;
    e_projeto_nao_cadastrado EXCEPTION;
BEGIN
    SELECT projeto.id INTO f_checa_id FROM brh.projeto WHERE projeto.id = f_id;
    IF SQL%NOTFOUND THEN
            RAISE e_projeto_nao_cadastrado;
    END IF;
    SELECT projeto.fim INTO f_check_data_vazia FROM brh.projeto WHERE projeto.id = f_id;
    IF f_check_data_vazia IS NULL THEN
        UPDATE brh.projeto SET projeto.fim = to_date(sysdate, 'DD/MM/YYYY') where id = f_id;
        SELECT projeto.fim INTO f_data_fim FROM brh.projeto WHERE projeto.id = f_id;
        RETURN f_data_fim;
    ELSE 
        RAISE e_projeto_ja_finalizado;
    END IF;
EXCEPTION
    WHEN e_projeto_ja_finalizado THEN
        raise_application_error(-20100, 'Projeto já finalizado');
    WHEN e_projeto_nao_cadastrado THEN
        raise_application_error(-20101, 'Projeto não cadastrado');
END;



END;


-- FIM OPCIONAIS