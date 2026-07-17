-- Questão 1: Listar todos os dados de todas as pessoas cadastradas.
SELECT * 
FROM Pessoa;

-- Questão 2: Listar nome, e-mail e data de nascimento das pessoas cadastradas.
SELECT nome, email, dt_nasc 
FROM Pessoa;

-- Questão 3: Listar nome, e-mail e data de nascimento da 3a a 8a pessoa cadastrada.
SELECT nome, email, dt_nasc 
FROM Pessoa 
ORDER BY id_pessoa
LIMIT 6 OFFSET 2;

-- Questão 4: Listar nome, e-mail e idade das pessoas cadastradas.
SELECT 
    nome, 
    email, 
    EXTRACT(YEAR FROM AGE(dt_nasc)) AS idade 
FROM Pessoa;

-- Questão 5: Listar a quantidade de agendamentos.
SELECT COUNT(*) AS qt_agendamentos 
FROM Agendamento;

-- Questão 6: Listar a data/hora das consultas e os respectivos valores com desconto de 5%. 
SELECT 
    data_hora_consulta, 
    'R$ ' || TO_CHAR(valor_consulta * 0.95, 'FM999G990D00') AS valor_com_desconto 
FROM Agendamento;

-- Questão 7: Listar nome, cpf e e-mail dos pacientes que não possuem plano de saúde.
SELECT 
    pe.nome, 
    pe.cpf, 
    pe.email 
FROM Paciente pa
INNER JOIN Pessoa pe ON pa.id_pessoa = pe.id_pessoa
WHERE pa.plano_saude = Nao;

-- Questão 8: Listar os dados dos agendamentos registrados para o mesmo mês da consulta.
SELECT * 
FROM Agendamento
WHERE EXTRACT(MONTH FROM dt_agendamento) = EXTRACT(MONTH FROM dt_consulta)
  AND EXTRACT(YEAR FROM dt_agendamento) = EXTRACT(YEAR FROM dt_consulta);

-- Questão 9: Listar cpf, nome e e-mail dos pacientes que não possuem telefone.
SELECT 
    pe.cpf, 
    pe.nome, 
    pe.email 
FROM Paciente pa
INNER JOIN Pessoa pe ON pa.id_pessoa = pe.id_pessoa
WHERE pe.telefone IS NULL;

-- Questão 10: Listar a data das consultas cujo o valor está entre R$ 50.00 e R$ 100.00.
SELECT CAST(dt__consulta AS DATE) AS dt_consulta 
FROM Agendamento
WHERE valor_consulta BETWEEN 50.00 AND 100.00;

-- Questão 11: Listar cpf, nome e e-mail dos pacientes que moram em "Natal".
SELECT 
    pe.cpf, 
    pe.nome, 
    pe.email 
FROM Paciente pa
INNER JOIN Pessoa pe ON pa.id_pessoa = pe.id_pessoa
WHERE pe.endereco ILIKE '%Natal%';

-- Questão 12: Listar cpf, nome, e-mail e data de nascimento dos pacientes ordenados pela data de nascimento.
SELECT 
    pe.cpf, 
    pe.nome, 
    pe.email, 
    pe.dt_nasc 
FROM Paciente pa
INNER JOIN Pessoa pe ON pa.id_pessoa = pe.id_pessoa
ORDER BY pe.dt_nasc ASC;

-- Questão 13: Listar a quantidade de pacientes que não possuem plano de saúde.
SELECT COUNT(*) AS total_sem_plano 
FROM Paciente
WHERE plano_saude = Nao;

-- Questão 14: Listar o maior e o menor valor das consultas agendadas para cada dia que contém consulta.
SELECT 
    CAST(dt_consulta AS DATE) AS dia_consulta,
    'R$ ' || TO_CHAR(MAX(valor_consulta), 'FM999G990D00') AS maior_valor,
    'R$ ' || TO_CHAR(MIN(valor_consulta), 'FM999G990D00') AS menor_valor
FROM Agendamento
GROUP BY CAST(dt_consulta AS DATE)
ORDER BY dia_consulta;

-- Questão 15: Listar a média dos valores das consultas agendadas para o mês de Dezembro.
SELECT 
    'R$ ' || TO_CHAR(AVG(valor_consulta), 'FM999G990D00') AS med_valor_dezembro
FROM Agendamento
WHERE EXTRACT(MONTH FROM dt_consulta) = 12;

-- Questão 16: Listar nome e e-mail das pessoas que agendaram alguma consulta para o dia do seu aniversário.
SELECT DISTINCT
    pe.nome, 
    pe.email 
FROM Agendamento ag
INNER JOIN Paciente pa ON ag.id_paciente = pa.id_paciente
INNER JOIN Pessoa pe ON pa.id_pessoa = pe.id_pessoa
WHERE EXTRACT(DAY FROM pe.dt_nasc) = EXTRACT(DAY FROM ag.data_hora_consulta)
  AND EXTRACT(MONTH FROM pe.dt_nasc) = EXTRACT(MONTH FROM ag.dt_consulta);

-- Questão 17: Listar o nome, e-mail, cpf dos médicos e as suas respectivas especialidades.
SELECT 
    pe.nome AS nome_medico, 
    pe.email, 
    pe.cpf, 
    es.descricao AS especialidade
FROM Medico me
INNER JOIN Pessoa pe ON me.id_pessoa = pe.id_pessoa
INNER JOIN Medico_Especialidade me_es ON me.id_medico = me_es.id_medico
INNER JOIN Especialidade es ON me_es.id_especialidade = es.id_especialidade;

-- Questão 18: Listar a quantidade de consultas para cada médico.
SELECT 
    pe.nome AS nome_medico, 
    COUNT(ag.id_agendamento) AS qt_consultas
FROM Medico me
INNER JOIN Pessoa pe ON me.id_pessoa = pe.id_pessoa
LEFT JOIN Agendamento ag ON me.id_medico = ag.id_medico
GROUP BY pe.nome
ORDER BY qt_consultas DESC;