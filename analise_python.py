# Carregar dados
bairros = carregar_bairros()

# Questão 1
data = format_data('2023-04-01')
chamados_dia = carregar_chamados(data, data)
total_chamados = chamados_dia.shape[0]
print(f"Total de chamados em {data}: {total_chamados}")

# Questão 2
tipo_mais_chamados = chamados_dia.groupby('tipo').size().sort_values(ascending=False).index[0]
print(f"Tipo com mais chamados em {data}: {tipo_mais_chamados}")

# Questão 3
chamados_bairro = chamados_dia.merge(bairros, how='left', on='id_bairro')
top_3_bairros = chamados_bairro.groupby('nome').size().sort_values(ascending=False).head(3).index.to_list()
print(f"Top 3 bairros com mais chamados em {data}: {top_3_bairros}")

# Questão 4
subprefeitura_mais_chamados = chamados_bairro.groupby('subprefeitura').size().sort_values(ascending=False).index[0]
print(f"Subprefeitura com mais chamados em {data}: {subprefeitura_mais_chamados}")

# Questão 5
chamados_sem_bairro = chamados_dia[chamados_dia['id_bairro'].isnull()]
print(f"Existem {chamados_sem_bairro.shape[0]} chamados sem bairro em {data}")

# Carregar dados
eventos = pd.read_csv('https://raw.githubusercontent.com/prefeitura-rio/dados-abertos/master/turismo/fluxo-visitantes/rede-hoteleira-ocupacao-eventos.csv')

# Questão 6
data_inicio = format_data('2022-01-01')
data_fim = format_data('2023-12-31')
chamados_perturbacao = carregar_chamados(data_inicio, data_fim)
total_chamados_perturbacao = chamados_perturbacao[chamados_perturbacao['subtipo'] == 'Perturbação do sossego'].shape[0]
print(f"Total de chamados com Perturbação do Sossego: {total_chamados_perturbacao}")

# Questão 7
chamados_eventos = chamados_perturbacao.merge(eventos, how='inner', left_on='data_particao', right_on='data_inicio')
print(chamados_eventos.head())

# Questão 8
chamados_por_evento = chamados_eventos.groupby('evento').size().to_frame('total_chamados')
print(chamados_por_evento)

# Questão 9
chamados_dia_evento = chamados_eventos.groupby(['evento', 'data_particao']).size().to_frame('total_chamados_dia')
media_diaria_evento = chamados_dia_evento.groupby('evento').mean()['total_chamados_dia']
print(media_diaria_evento)

# Questão 10
# Cálculo da média diária geral
chamados_dia = chamados_perturbacao.groupby('data_particao').size().to_frame('total_chamados_dia')
media_diaria_geral = chamados_dia.mean()['total_chamados_dia']

# Cálculo da média diária por evento
chamados_dia_evento = chamados_eventos.groupby(['evento', 'data_particao']).size().to_frame('total_chamados_dia')
media_diaria_evento = chamados_dia_evento.groupby('evento').mean()['total_chamados_dia']

# Comparação
print(f"Média diária geral: {media_diaria_geral}")
print(f"Média diária por evento:")
print(media_diaria_evento)

# Visualização (opcional)
import matplotlib.pyplot as plt

plt.bar(['Geral', 'Reveillon', 'Carnaval', 'Rock in Rio'], [media_diaria_geral] + list(media_diaria_evento))
plt.xlabel('Evento')
plt.ylabel('Média diária de chamados')
plt.show()
