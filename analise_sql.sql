-- Questão 1: Quantos chamados foram abertos no dia 01/04/2023? R: Foram abertos 65938 chamados.
SELECT COUNT(*) AS total
FROM datario.administracao_servicos_publicos.chamado_1746
WHERE data_particao = '2023-04-01';

-- Questão 2: Qual o tipo de chamado que teve mais teve chamados abertos no dia 01/04/2023? R: Estacionamento Irregular, total de 10256 chamados.
SELECT tipo, COUNT(*) AS total
FROM datario.administracao_servicos_publicos.chamado_1746
WHERE data_particao = '2023-04-01'
GROUP BY tipo
ORDER BY total DESC
LIMIT 1;

--Questão 3: Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia? R:Campo Grande (2351), Tijuca (2351) e Barra da Tijuca (1978). 
SELECT b.nome AS id_bairro, COUNT(*) AS total
FROM datario.administracao_servicos_publicos.chamado_1746 AS c
INNER JOIN datario.dados_mestres.bairro AS b
ON c.id_bairro = b.id_bairro 
WHERE c.data_particao = '2023-04-01'
GROUP BY b.nome
ORDER BY total DESC
LIMIT 3;

-- Questão 4: Qual o nome da subprefeitura com mais chamados abertos nesse dia? R: Subprefeitura Zona Norte (19560)
SELECT b.subprefeitura, COUNT(*) AS total_chamados
FROM datario.administracao_servicos_publicos.chamado_1746 AS c
INNER JOIN datario.dados_mestres.bairro AS b
ON c.id_bairro = b.id_bairro
WHERE c.data_particao = '2023-04-01'
GROUP BY b.subprefeitura
ORDER BY total_chamados DESC
LIMIT 1;

--Questão 5: Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece? R:Sim, acontece Local fora da cobertura, no qual o chamado pode ter sido feito em um local fora da área de cobertura da tabela de bairros.
SELECT c.id_bairro, c.data_particao, c.tipo, c.latitude, c.longitude, b.nome AS bairro
  FROM datario.administracao_servicos_publicos.chamado_1746 AS c
  LEFT JOIN datario.dados_mestres.bairro AS b
  ON c.id_bairro = b.id_bairro
  WHERE b.id_bairro IS NULL
  AND c.data_particao = '2023-04-01'
  LIMIT 100;

