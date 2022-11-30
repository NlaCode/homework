SELECT
  cupom.id_filial, cupom.codigo_pdv, date_format(cupom.data_cupom, '01/MM/yyyy'), produto.id_departamento,
  CASE
    WHEN (
      produto.id_departamento IN (25, 37, 40, 41, 42, 43, 44, 45, 46, 47, 53) OR produto.id_secao IN (1318, 1331, 1337, 1475)
    ) THEN 2
    ELSE 1
  END id_loja_emporio,
  CASE
    WHEN (
      produto.id_departamento IN (25, 37, 40, 41, 42, 43, 44, 45, 46, 47, 53) OR produto.id_secao IN (1318, 1331, 1337, 1475)
    ) THEN 'EMPORIO'
    ELSE 'LOJA'
  END AS loja_emporio,
  COUNT(DISTINCT cupom.id_cupom), SUM(
    cupom.preco_total_item - cupom.valor_desconto_item + cupom.valor_acrescimo_item
  ) AS total_faturado,
  COUNT(DISTINCT cupom.quantidade_item)
FROM
  bi_vendas_gold.f_cupom_item as cupom
  LEFT JOIN bi_vendas_gold.dim_filial as filial on filial.id = cupom.id_filial
  LEFT JOIN bi_vendas_gold.dim_produto as produto on produto.ID = cupom.id_produto
WHERE
  cupom.data_cupom BETWEEN date_trunc('year', current_date) - (interval '1 year')
  AND current_date - (interval '1 day') and filial.id_empresa IN (2, 15)
  and cupom.situacao_cupom = 1 and cupom.situcao_item = 0
GROUP by
  date_format(cupom.data_cupom, '01/MM/yyyy'), cupom.id_filial, cupom.codigo_pdv, produto.id_departamento, produto.id_secao