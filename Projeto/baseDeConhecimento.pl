%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de conhecimento
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% e_ad = Entidade Adjudicante    - Uma empresa pública que quer contratar,(Ex:CP)
% e_ada = Entidade Adjudicatária - A empresa contratada,(Ex:GALP)
 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Entidades Adjudicante(Nome,Nif,Morada) ->{V,F}
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

e_ad('CP - Comboios de Portugal',700000000,'Cc Do Duque 14/20, 1249-109, Misericordia Lisboa, Lisboa').
e_ad('BRISA - Autoestradas de Portugal, S.A.',700000001,'Qta Torre Da Aguilha Edifício Brisa, 2785-599, Sao Domingos Rana Cascais, Lisboa').
e_ad('NAV Portugal, EPE',700000003,'R D Do Aeroporto De Lisboa Edifício 121 3º, 1700-008, Santa Maria Olivais Lisboa, Lisboa').
e_ad('ULSAM - Unidade Local de Saúde do Alto Minho, EPE',700000004,'Estr. De Santa Luzia 50, Viana Do Castelo').
e_ad('CGD - Caixa Geral de Depósitos, SA',700000005,'Av João Xxi 63, 1000-300, Areeiro Lisboa, Lisboa').
e_ad('PME Investimentos - Sociedade de Investimentos, SA',700000006,'Rua Pedro Homem De Melo, 55, S.3.09, 4150-599 Porto').


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Entidades adjudicatária(Nome,Nif,Morada) ->{V,F}
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

e_ada('PETROGAL, S.A',300000000,'R Tomás Da Fonseca Torre C, 1600-209, Sao Domingos Benfica Lisboa, Lisboa').
e_ada('EDP',300000001,'Av 24 De Julho 12, 1249-300, Misericordia Lisboa, Lisboa').
e_ada('Pingo Doce',300000002,'R Actor António Silva 7, 1649-033, Lumiar Lisboa, Lisboa').
e_ada('TAP',300000003,'Aeroporto De Lisboa Efifício 27-8 Sala 1, 1700-008, Santa Maria Olivais Lisboa, Lisboa').
e_ada('GALP',300000004,'R Tomás Da Fonseca Torre C, 1600-209, Sao Domingos Benfica Lisboa').
e_ada('CTT',300000005,'Av Dom João Ii 13, 1999-001, Parque Nacoes Lisboa, Lisboa').
e_ada('PRIO SUPPLY, S.A.',300000006,'Porto De Pesca De Aveiro Lote B, 3830-565, Gafanha Nazare Ilhavo, Aveiro').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Contratos (ID,NifAd, NifAda, TipoDeContrato, TipoDeProcedimento, Descrição, Valor, Prazo, Local, Data ) -> {V,F}
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

contrato(1,700000000,300000000,'Aquisicao de Servicos','Consulta Previa','Fornecimento de petrólio',50000,365,'Lisboa',"01-01-2018"). % CP-PETROGAL
contrato(2,700000000,700000005,'Aquisicao de Servicos','Ajuste Direto','contrato de intermediação financeira',2500,366,'Lisboa',"01-04-2020"). % CP-CGD
contrato(3,700000001,300000006,'Aquisicao de Servicos','Concurso Publico','Controlo das portagens ',100000,365,'Lisboa',"06-01-2010"). % BRISA-PRIO
contrato(4,700000004,300000001,'Aquisicao de Servicos','Consulta Previa','Fornecimento de energia',100000,365,'Viana do Castelo',"06-01-2013"). % ULSAM-EDP
contrato(5,700000004,300000004,'Aquisicao de Servicos','Concurso Publico','Fornecimento de Gas Natural ',30000,365,'Viana do Castelo',"03-01-2010"). % ULSAM-GALP
contrato(6,700000003,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',5000000,1096,'Lisboa',"06-01-2017"). % NAV-TAP
contrato(7,700000003,300000003,'Locacao de bens moveis','Ajuste Direto','Combustivel para automeveis',5000,30,'Porto',"06-01-2018"). % GALP-TAP
contrato(9,700000006,700000004,'Aquisicao de Servicos','Consulta Previa','Compra de protecoes contra o Covid19',50000,180,'Lisboa',"01-02-2019"). % PME-ULSAM
contrato(10,700000005,700000004,'Empreitadas de obras públicas','Consulta Previa','Investimento publico para a construção de um novo hospital ',5000000,180,'Viana do Castelo',"01-01-2020"). % CGD-ULSAM


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Conhecimento imperfeito
%-------------------------------- - - - - - - - - - -  -  -  -  -   -

excecao(e_ad('Municipio de Moncao, S.A',700000007,impreciso('Moncao ou Mazedo')),impreciso).
excecao(e_ad('EDM - Empresa de Desenvolvimento Mineiro',700000008,impreciso('Lisboa')),impreciso).
excecao(e_ad(('I','Universidade do Minho, U.M'),('I',700000009),interdito('Largo do Paço, 4704-553 Braga')),interdito).
excecao(e_ad('Universidade do Minho, U.M',700000009,'-'),info_interdito).

excecao(e_ada('REPSOL Portugues, S.A',300000007,'N/A'),incerto).
excecao(e_ada('MOTA-ENGIL',300000009,'N/A'),incerto).
excecao(e_ada('RADIO POPULAR',300000010,impreciso('Porto','Famalicão')),impreciso).

excecao(contrato(('I',8),700000006,300000005,'Aquisicao de Servicos','Ajuste Direto',interdito('Distribuicao de correio'),3000,365,'Porto',"06-01-2020"),interdito).
excecao(contrato(8,700000006,300000005,'Aquisicao de Servicos','Ajuste Direto','-',3000,365,'Porto',"06-01-2020"),info_interdito).
excecao(contrato(11,700000003,300000005,'Aquisicao de Servicos','Ajuste Direto','Distribuicao de correio',3000,365,'N/A',"23-03-2010"),incerto).



%-------------------------------- - - - - - - - - - -  -  -  -  -   -
%-------------------------------- - - - - - - - - - -  -  -  -  -   -






