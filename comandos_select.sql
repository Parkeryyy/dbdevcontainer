-- 1. Listar todos os dados de todas as pessoas cadastradas.
SELECT *
FROM pessoa;

--2. Listar nome, e-mail e data de nascimento das pessoas cadastradas.
SELECT nome, email, dt_nasc
FROM pessoa;

--3. Listar nome, e-mail e data de nascimento da 3a a 8a pessoa cadastrada.
--Ordenado por cpf
SELECT nome, email, dt_nasc
FROM pessoa
ORDER BY cpf
LIMIT 6 OFFSET 2

--4. Listar nome, e-mail e idade das pessoas cadastradas.
--AGE() calcula a idade de acordo com a data de nascimento.
--EXTRACT pega só o valor do ano.
SELECT nome, email, EXTRACT(YEAR FROM AGE(CURRENT_DATE, dt_nasc)) AS idade
FROM pessoa;

--5. Listar a quantidade de agendamentos.
SELECT COUNT(*) AS qt_agendamentos
FROM agendamento;

--6. Listar a data/hora das consultas e os respectivos valores com desconto de 5%
--Valores precedidos com "R$"
SELECT dt_consulta, CONCAT('R$ ', TO_CHAR(valor_consulta * 0.95, 'FM999G990D00')) AS valor_deseconto
FROM agendamento;

--7. Lista nome, cpf e e-mail dos pacientes que não possuem plano de saúde.
SELECT pe.nome, pe.cpf, pe.email 
FROM paciente pa
JOIN pessoa pe ON pa.cpf_pessoa = pe.cpf
WHERE pa.plano_saude = Nao;

--8. Listar os dados agendamentos registrados para o mesmo mes da consulta.
SELECT *
FROM agendamento
WHERE EXTRACT(MONTH FROM dt_agendamento) = EXTRACT(MONTH FROM dt_consulta)
    AND EXTRACT(YEAR FROM dt_agendamento) = EXTRACT(YEAR FROM dt_consulta);

--9. Listar cpf, nome e e-mail dos pacientes que nao possuem telefone.
SELECT pe.cpf, pe.nome, pe.email
FROM paciente pa
JOIN pessoa pe ON pa.cpf_pessoa = pe.cpf
WHERE pe.telefone IS NULL OR pe.telefone = '';

--10. Listar a data das consultas cujo o valor está entre R$ 50.00 e R$100.00.
SELECT CAST(dt_consulta AS DATE) AS dt_consulta
FROM agendamento
WHERE valor_consulta BETWEEN 50.00 AND 100.00;

--11. Listar cpf, nome e e-mail dos pacientes que moram em "Natal".
SELECT pe.cpf, pe.nome, pe.email
FROM paciente pa
JOIN pessoa pe ON pa.cpf_pessoa = pe.cpf
WHERE pe.endereco ILIKE '%Natal%';

--12. Listar cpf, nome, e-mail e data de nascimento dos pacientes order=nadoes pela data de nascimento.
SELECT pe.cpf, pe.nome, pe.email, pe.dt_nasc
FROM paciente pa
JOIN pessoa pe ON pa.cpf_pessoa = pe.cpf
ORDER BY pe.dt_nasc ASC;

--13. Listar a quantidade de pacientes que não possuem plano de saúde.
SELECT COUNT(*) AS tot_pac_sem
FROM paciente
WHERE plano_saude = Nao;

--14. Listar o maior e o menor valor das consultas agendadas para cada dia que contém consulta.
SELECT CAST(dt_consulta AS DATE) AS dia_consulta,
    MAX(valor_consulta) AS maior_valor,
    MIN(valor_consulta) AS menor_valor
FROM agendamento
GROUP BY CAST(dt_consulta AS DATE)
ORDER BY dia_consulta;

--15. Lista a média dos valores das consultas agendadas para o mes de Dezembro.
SELECT AVG(Valor_consulta) AS med_valor_dezembro
FROM agendamento
WHERE EXTRACT(MONTH FROM dt_consulta) = 12;

--16. Listar nome e e-mail das pessoas que agendaram alguma consulta para o dia do deu aniversário
--Compara o dia e o mes de nascimento da pessoa com a data da consulta
SELECT DISTINCT pe.nome, pe.email
FROM agendamento ag
JOIN paciente pa ON ag.cpf_paciente = pa.cpf_pessoa
JOIN pessoa pe ON pa.cpf_pessoa = pe.cpf
WHERE EXTRACT(DAY FROM ag.dt_consulta) = EXTRACT(DAY FROM pe.dt_nasc)
    AND EXTRACT(MONTH FROM ag.dt_consulta) = EXTRACT(MONTH FROM pe.dt_nasc);

--17 Listar o nome, e-mail, cpf dos medicos e suas respectivas especialidades.
-- tabela associativa "Medico_Especialidade", relação N:N
SELECT pe.nome AS nome_medico, pe.email, pe.cpf, esp.descricao AS especialidade
FROM medico m
JOIN pessoa pe ON m.cpf_pessoa = pe.cpf
JOIN Medico_Especialidade me ON m.crm = me.crm_medico
JOIN especialidade esp ON me.id_especialidade = esp.identificador;

--18 Listar a quantidade de consultas para cada medico.
SELECT pe.nome AS nome_medico, COUNT(ag.dt_consulta) AS qt_consultas
FROM medico m
JOIN pessoa pe ON m.cpf_pessoa = pe.cpf
LEFT JOIN agendamento ag ON m.crm = ag.crm_medico
GROUP BY pe.nome, m.crm
ORDER BY qt_consultas DESC;