FAETERJ-Rio
Analise e Projeto de Sistemas
Minimundo Bazar Marketplace
O bazar TemTudo precisa de um sistema para processar pedidos vindos de grandes players de mercado
de e-commerce, conhecidos como Marketplaces. Essas empresas oferecem produtos de empresas
terceiras para o público consumidor. O bazar hoje trabalha com as empresas Amazon, Americanas,
Walmart, Mercado livre, eBay e outras. Os pedidos chegam através de arquivos csv baixados de uma
area de FTP de cada marketplace. Esses arquivos devem ser carregados para o banco de dados e
processados os pedidos. O arquivo possui uma linha para cada produto vendido, assim se um cliente
comprar três produtos em um mesmo pedido, haverão três linhas no arquivo, uma para cada produto.
Cada linha do arquivo identifica também o pedido através de um código do pedido.
O arquivos contém os seguintes campos:
order-id, order-item-id, purchase-date, payments-date, buyer-email, buyer-name, cpf,
buyer-phone-number, sku, product-name, quantity-purchased, currency, item-price,ship-service-level,
recipient-name, ship-address-1, ship-address-2, ship-address-3, ship-city, ship-state, ship-postal-code,
ship-country, ioss-number.
Os pedidos devem ser carregados em uma tabela de carga temporária com os mesmos campos do
arquivo csv.
Após os pedidos serem carregados na tabela de carga (temporária), devem ser usados para carregar as
tabelas de Pedidos, ItensPedido, Clientes e Produtos.
A tabela de Clientes deve receber todos os clientes novos, não existentes na tabela. A tabela de produtos
segue a mesma lógica, deve receber produtos que por ventura não estejam cadastrados, mas foram
vendidos.
A tabela de pedidos deve receber todos os pedidos, necessário atenção porque a tabela de carga pode
possuir mais de uma linha para o mesmo pedido. Um pedido na tabela de carga é identificado pela
coluna “order-id”, que pode estar repetido em mais de uma linha.
A tabela itensPedido deve ser atualizada com todos os itens de pedido constantes da tabela carga. Cada
linha de Carga é uma linha de itensPedido.
É importante notar que devem haver chaves estrangeiras nas tabelas para que o relacionamento seja
perfeito. Assim é necessário especial atenção na ordem das inserções.
Após inserir os dados nas tabelas de sistema, o Analista deve atualizar a tabela de movimentação de
estoque com a ordem de atendimento de produto segundo a regra de negócio. O atendimento dos
pedidos completos deve ser ordenado do maior valor para o menor. Assim os pedidos de maior valor,
com todos os produtos, devem ser atendidos primeiro. Para cada produto de cada pedido a ser
processado, deve ser registrado na tabela de movimentação a quantidade do produto em estoque. Após
o registro feito, o sistema deve debitar do estoque a quantidade debitada e atualizar o saldo para cada

produto. Os pedidos que não forem atendidos em sua totalidade devem ser registrados na tabela de
compras com os dados do produto a ser comprado.
Os produtos comprados, ao chegarem ao estoque, devem atualizar a tabela de produtos com o estoque.
A atualização deve usar um arquivo CSV com os dados dos produtos entregues pelo fornecedor.
