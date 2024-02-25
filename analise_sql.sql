## Localização de chamados do 1746 , Utilizando a tabela de Chamados do 1746 e a tabela de Bairros do Rio de Janeiro para as perguntas de 1-5. ##

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


## Chamados do 1746 em grandes eventos, utilizando a tabela de Chamados do 1746 e a tabela de Ocupação Hoteleira em Grandes Eventos no Rio para as perguntas de 6-10. ##

--Questão 6: Quantos chamados com o subtipo "Perturbação do sossego" foram abertos desde 01/01/2022 até 31/12/2023 (incluindo extremidades)? R: 42408
SELECT COUNT(*) AS total
FROM datario.administracao_servicos_publicos.chamado_1746 AS c
WHERE c.data_particao BETWEEN '2022-01-01' AND '2023-12-31'
AND c.subtipo = 'Perturbação do sossego';

--Questão 7: Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio). R:
SELECT c.id_chamado, c.data_inicio, c.subtipo, c.id_bairro, e.evento
FROM datario.administracao_servicos_publicos.chamado_1746 AS c
INNER JOIN datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos AS e
ON c.data_particao BETWEEN e.data_inicial AND e.data_final
WHERE c.subtipo = 'Perturbação do sossego'
AND e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio');

-- Questão 8: Quantos chamados desse subtipo foram abertos em cada evento? R: Reveillon (79), Carnaval (197), Rock in Rio (518)
SELECT e.evento, COUNT(*) AS total_chamados
FROM datario.administracao_servicos_publicos.chamado_1746 AS c
INNER JOIN datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos AS e
ON c.data_inicio BETWEEN e.data_inicial AND e.data_final
WHERE c.subtipo = 'Perturbação do sossego'
AND e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
GROUP BY e.evento;

-- Questão 9: Qual evento teve a maior média diária de chamados abertos desse subtipo? R: Reveillon com 2129 chamados abertos.
SELECT evento, AVG(total_chamados_dia) AS media_diaria
FROM (
  SELECT e.evento, COUNT(*) AS total_chamados_dia
  FROM datario.administracao_servicos_publicos.chamado_1746 AS c
  INNER JOIN datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos AS e
  ON c.data_particao BETWEEN e.data_inicial AND e.data_final
  WHERE c.subtipo = 'Perturbação do sossego'
  AND e.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
  GROUP BY e.evento, c.data_particao
) AS t
GROUP BY evento;

-- Questão 10: Compare as médias diárias de chamados abertos desse subtipo durante os eventos específicos (Reveillon, Carnaval e Rock in Rio) e a média diária de chamados abertos desse subtipo considerando todo o período de 01/01/2022 até 31/12/2023. R:

