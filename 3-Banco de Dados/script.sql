
CREATE TABLE demonstracoes_contabeis (
    data DATE NOT NULL,
    reg_ans INT NOT NULL,
    cd_conta_contabil VARCHAR(50) NOT NULL,
    descricao TEXT NOT NULL,
    vl_saldo_inicial DECIMAL(15,2),
    vl_saldo_final DECIMAL(15,2),
    PRIMARY KEY (data, reg_ans, cd_conta_contabil)
);


CREATE TABLE operadoras_ativas (
    registro_ans INT PRIMARY KEY,
    cnpj VARCHAR(18) NOT NULL,
    razao_social TEXT NOT NULL,
    nome_fantasia TEXT,
    modalidade TEXT,
    logradouro TEXT,
    numero VARCHAR(10),
    complemento TEXT,
    bairro TEXT,
    cidade TEXT,
    uf CHAR(2),
    cep VARCHAR(9),
    ddd VARCHAR(3),
    telefone VARCHAR(15),
    fax VARCHAR(15),
    endereco_eletronico TEXT,
    representante TEXT,
    cargo_representante TEXT,
    regiao_de_comercializacao TEXT,
    data_registro_ans DATE
);


DO $$ 
DECLARE 
    filename TEXT;
    file_path TEXT := './csv/'; 
    filenames TEXT[] := ARRAY[
        '1T2023.csv', '2t2023.csv', '3T2023.csv', '4T2023.csv',
        '1T2024.csv', '2T2024.csv', '3T2024.csv', '4T2024.csv'
    ];
BEGIN
    FOREACH filename IN ARRAY filenames LOOP
        EXECUTE format(
            'COPY demonstracoes_contabeis FROM %L DELIMITER '';'' CSV HEADER ENCODING ''LATIN1'';',
            file_path || filename
        );
    END LOOP;
END $$;

COPY operadoras_ativas FROM './csv/Relatorio_cadop.csv'
DELIMITER ';' CSV HEADER ENCODING 'LATIN1';

SELECT o.nome_fantasia, o.razao_social, SUM(d.vl_saldo_final - d.vl_saldo_inicial) AS total_despesas
FROM demonstracoes_contabeis d
JOIN operadoras_ativas o ON d.reg_ans = o.registro_ans
WHERE d.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR'
AND d.data >= (CURRENT_DATE - INTERVAL '3 months')
GROUP BY o.nome_fantasia, o.razao_social
ORDER BY total_despesas DESC
LIMIT 10;

SELECT o.nome_fantasia, o.razao_social, SUM(d.vl_saldo_final - d.vl_saldo_inicial) AS total_despesas
FROM demonstracoes_contabeis d
JOIN operadoras_ativas o ON d.reg_ans = o.registro_ans
WHERE d.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR'
AND d.data >= (CURRENT_DATE - INTERVAL '1 year')
GROUP BY o.nome_fantasia, o.razao_social
ORDER BY total_despesas DESC
LIMIT 10;
