CREATE TABLE Pessoa (
    cpf CHAR(11) PRIMARY KEY,
    email VARCHAR(50) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    dt_nasc DATE NOT NULL,
    endereco VARCHAR(300) NOT NULL,
    telefone VARCHAR(15),
    CONSTRAINT unique_email_nome UNIQUE (email, nome)
);

CREATE TABLE Paciente (
    codigo VARCHAR(10) PRIMARY KEY,
    senha VARCHAR(10) NOT NULL CHECK (LENGTH(senha) BETWEEN 5 AND 10),
    plano_saude VARCHAR(3) NOT NULL CHECK (plano_saude IN ('Sim', 'Nao')),
    cpf CHAR(11) NOT NULL UNIQUE,
    CONSTRAINT fk_paciente_pessoa FOREIGN KEY (cpf) REFERENCES Pessoa(cpf) ON DELETE CASCADE
);

CREATE TABLE Medico (
    crm VARCHAR(20) PRIMARY KEY,
    cpf CHAR(11) NOT NULL UNIQUE,
    CONSTRAINT fk_medico_pessoa FOREIGN KEY (cpf) REFERENCES Pessoa(cpf) ON DELETE CASCADE
);

CREATE TABLE Especialidade (
    identificador INT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE Medico_Especialidade (
    crm VARCHAR(20),
    identificador INT,
    PRIMARY KEY (crm, identificador),
    CONSTRAINT fk_possui_medico FOREIGN KEY (crm) REFERENCES Medico(crm) ON DELETE CASCADE,
    CONSTRAINT fk_possui_especialidade FOREIGN KEY (identificador) REFERENCES Especialidade(identificador) ON DELETE CASCADE
);

CREATE TABLE Agendamento (
    codigo_paciente VARCHAR(10),
    crm_medico VARCHAR(20),
    dt_consulta TIMESTAMP,
    dt_agendamento TIMESTAMP NOT NULL,
    valor_consulta DECIMAL(10, 2) NOT NULL CHECK (valor_consulta > 0),
    PRIMARY KEY (codigo_paciente, crm_medico, dt_consulta),
    CONSTRAINT fk_agendamento_paciente FOREIGN KEY (codigo_paciente) REFERENCES Paciente(codigo) ON DELETE RESTRICT,
    CONSTRAINT fk_agendamento_medico FOREIGN KEY (crm_medico) REFERENCES Medico(crm) ON DELETE RESTRICT
);