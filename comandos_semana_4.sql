--Procedure para criar projetos:


CREATE OR REPLACE PROCEDURE brh.cria_projeto
    (p_nome brh.projeto.nome%type, p_responsavel brh.projeto.responsavel%type)
IS
BEGIN
    INSERT INTO brh.projeto(nome, responsavel, inicio) VALUES (p_nome, p_responsavel, to_date(sysdate, 'DD/MM/YYYY'));
    
END;


--Função para calcular idade:

CREATE OR REPLACE FUNCTION brh.calcula_idade
    (f_data_nascimento IN varchar2)
    RETURN NUMBER
IS
    f_idade NUMBER;
BEGIN
    SELECT  FLOOR(MONTHS_BETWEEN(sysdate, (to_date(f_data_nascimento, 'DD/MM/YYYY')))/12) INTO f_idade FROM DUAL;
    RETURN f_idade;
END;


--Comando teste para testar a função:

SET SERVEROUTPUT ON;

DECLARE
    t_IDADE NUMBER;
BEGIN
    t_IDADE := brh.calcula_idade('26/07/1998');
    dbms_output.put_line('A idade é: ' || t_IDADE);
END;