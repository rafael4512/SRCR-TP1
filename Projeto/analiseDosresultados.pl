% Teste usado na analise de resultados
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Criação de uma entidade
novoAdjudicante('Municipio de Braga, M.B',700000031,'Praça do Município, 4700-435 Braga').
encontraAdjudicante(700000031,E).

% Invariante do Adjudicante
novoContrato(ID,700000031,300000003,'Locacao de bens moveis','Ajuste Direto','Combustivel para automoveis',5001,30,'Porto',"06-01-2018").
novoContrato(ID,700000031,300000003,'Locacao de bens moveis','Ajuste Direto','Combustivel para automoveis',5000,30,'Porto',"06-05-2018").



% Invariante dos 3 anos
novoContrato(ID,700000031,300000003,'Contrato De Aquisicao','Consulta Previa','Combustivel para automoveis',70000,365,'Braga',"07-01-2019").
somarContratos(700000031,300000003,[2018,2019,2020],Tot).
novoContrato(ID,700000031,300000003,'Contrato De Aquisicao','Consulta Previa','Combustivel para automoveis',10000,30,'Braga',"07-01-2020").

% Extra
topEntidadesAd(TOP).


% Imprefeito


novoContrato(ID,700000031,300000003,'Aquisicao de Servicos',interdito('Concurso Publico'),interdito('Fornecimento de Luz'),interdito(30000),365,'Porto',"08-01-2018",interdito).
encontraContrato2(('I',12),C).
encontraContrato2(12,C).
subsContrato(12,700000031,300000001,'Aquisicao de Servicos','Concurso Publico','Fornecimento de Luz',interdito(30000),365,'Porto',"08-01-2018",interdito).
subsContrato(12,700000031,300000001,'Aquisicao de Servicos','Concurso Publico','Fornecimento de Luz',30000,365,'Porto',"08-01-2018").
encontraContrato(12,R).


novoContrato(ID,700000031,300000001,'Aquisicao de Servicos',impreciso('Ajuste Direto','Consulta Previa'),incerto,3500,30,'Porto',"09-01-2018",incerto).
subsContrato(13,700000031,300000001,'Aquisicao de Servicos','Consulta Previa','Aumento nivel Tensão',3500,30,'Porto',"09-01-2018").
novoContrato(ID,700000031,300000001,'Contrato De Aquisicao',impreciso('Ajuste Direto','Consulta Previa'),impreciso('Paineis solares','Disjuntores'),3500,365,'Porto',"09-03-2020",impreciso).
subsContrato(14,700000031,300000001,'Contrato De Aquisicao','Ajuste Direto','Paineis solares',4000,365,'Porto',"09-03-2020").
encontraContrato2(14,R).


encontraTodosConAcimaDe(1000,em_vigor,R).


