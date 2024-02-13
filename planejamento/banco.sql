use transapp;

-- Criação da tabela de caminhões
CREATE TABLE TBcaminhao (
    Placa VARCHAR(8) PRIMARY KEY
);

-- Criação da tabela de caminhoneiros
CREATE TABLE TBcaminhoneiro (
    ID INT PRIMARY KEY,
	Nome VARCHAR(50),
    Usuario varchar(10),
    Senha VARCHAR(20)
);

-- Criação da tabela de fretes
CREATE TABLE TBfrete (
    ID INT PRIMARY KEY,
    idCaminhoneiro INT,
    placaCaminhao VARCHAR(9),
    Origem VARCHAR(40),
    Destino VARCHAR(40),
    valorCompra DECIMAL(10, 2),
    valorVenda DECIMAL(10, 2),
	data DATETIME,
    status enum("Em andamento", "Concluido"),
    FOREIGN KEY (idCaminhoneiro) REFERENCES TBcaminhoneiro(ID),
    FOREIGN KEY (placaCaminhao) REFERENCES TBcaminhao(Placa)
);

-- Criação da tabela de pagamentos
CREATE TABLE TBpagamentos (
    ID INT PRIMARY KEY,
    idCaminhoneiro INT,
    data DATETIME,
    Valor DECIMAL(10, 2),
    FOREIGN KEY (idCaminhoneiro) REFERENCES TBcaminhoneiro(ID)
);

-- Criação da tabela de abastecimento
CREATE TABLE TBabastecimento (
    ID INT PRIMARY KEY,
    idCaminhoneiro INT,
    placaCaminhao VARCHAR(9),
    litrosAbastecidos DECIMAL(8, 2),
    Volume DECIMAL(15, 2),
	data DATETIME,
    FOREIGN KEY (idCaminhoneiro) REFERENCES TBcaminhoneiro(ID),
    FOREIGN KEY (placaCaminhao) REFERENCES TBcaminhao(Placa)
);

-- Criação da tabela de despesas
CREATE TABLE TBdespesas (
    ID INT PRIMARY KEY,
    idCaminhoneiro INT,
    placaCaminhao VARCHAR(9),
    Valor DECIMAL(10, 2),
    Descricao VARCHAR(100),
	data DATETIME,
    FOREIGN KEY (idCaminhoneiro) REFERENCES TBcaminhoneiro(ID),
    FOREIGN KEY (placaCaminhao) REFERENCES TBcaminhao(Placa)
);


