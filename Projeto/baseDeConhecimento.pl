%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de conhecimento
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% e_ad = Entidade Adjudicante    - Uma empresa pública que quer contratar,(Ex:CP)
% e_ada = Entidade Adjudicatária - A empresa contratada,(Ex:GALP)
 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Entidades Adjudicante(Nome,Nif,Morada) ->{V,F}
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

e_ad('CP - Comboios de Portugal',700000000,'Portugal').
e_ad('BRISA - Autoestradas de Portugal, S.A.',700000001,'Portugal').
e_ad('NAV Portugal, EPE',700000003,'Portugal').
e_ad('ULSAM - Unidade Local de Saúde do Alto Minho, EPE',700000004,'Portugal').
e_ad('CGD - Caixa Geral de Depósitos, SA',700000005,'Portugal').
e_ad('PME Investimentos - Sociedade de Investimentos, SA',700000006,'Portugal').


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Entidades adjudicatária(Nome,Nif,Morada) ->{V,F}
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

e_ada('PETROGAL, S.A',300000000,'Portugal').
e_ada('EDP',300000001,'Portugal').
e_ada('Pingo Doce',300000002,'Portugal').
e_ada('TAP',300000003,'Portugal').
e_ada('GALP',300000004,'Portugal').
e_ada('CTT',300000005,'Portugal').
e_ada('PRIO SUPPLY, S.A.',300000006,'Portugal').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Contratos (ID,NifAd, NifAda, TipoDeContrato, TipoDeProcedimento, Descrição, Valor, Prazo, Local, Data ) -> {V,F}
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

contrato(1,700000000,300000000,'Aquisicao de Servicos','Consulta Previa','Fornecimento de petrólio',50000,365,'Lisboa',"01-01-2018"). % CP-PETROGAL
contrato(2,700000000,700000005,'Aquisicao de Servicos','Ajuste Direto','contrato de intermediação financeira',25000,366,'Lisboa',"01-04-2020"). % CP-CGD
contrato(3,700000001,300000006,'Aquisicao de Servicos','Concurso Público','Controlo das portagens ',100000,365,'Lisboa',"06-01-2010"). % BRISA-PRIO
contrato(4,700000004,300000001,'Aquisicao de Servicos','Consulta Previa','Fornecimento de energia',100000,365,'Viana do Castelo',"06-01-2013"). % ULSAM-EDP
contrato(5,700000004,300000004,'Aquisicao de Servicos','Concurso Público','Fornecimento de Gas Natural ',30000,365,'Viana do Castelo',"03-01-2010"). % ULSAM-GALP
contrato(6,700000003,300000003,'Aquisicao de Servicos','Concurso Público','Controlo do trafego aerio ',5000000,1096,'Lisboa',"06-01-2017"). % NAV-TAP
contrato(7,700000003,300000003,'Locacao de bens moveis','Ajuste Direto','Combustivel para automeveis',5000,30,'Porto',"06-01-2018"). % GALP-TAP
contrato(9,700000006,700000004,'Aquisicao de Servicos','Consulta Previa','Compra de protecoes contra o Covid19',50000,180,'Lisboa',"01-02-2019"). % PME-ULSAM
contrato(10,700000005,700000004,'Empreitadas de obras públicas','Consulta Previa','Investimento publico para a construção de um novo hospital ',5000000,180,'Viana do Castelo',"01-01-2020"). % CGD-ULSAM


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Conhecimento imperfeito
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

excecao(e_ad('Municipio de Monção, S.A',700000007,'Monção ou Mazedo'),impreciso).
excecao(e_ad('EDM - Empresa de Desenvolvimento Mineiro',700000008,'Porto ou Lisboa'),impreciso).


excecao(e_ada('REPSOL Portugues, S.A',300000007,'N/A'),incerto).
excecao(e_ada('N/A',300000008,'Braga'),incerto).
excecao(e_ada('MOTA-ENGIL',300000009,'Porto'),incerto).
excecao(e_ada('RADIO POPULAR',300000010,'Porto ou Lisboa'),impreciso).

excecao(contrato(8,700000006,300000005,'Aquisicao de Servicos','Ajuste Direto','Distribuicao de correio',3000,365,'Porto',"06-01-2020"),interdito).
excecao(contrato(11,700000003,300000005,'Aquisicao de Servicos','Ajuste Direto','Distribuicao de correio',3000,365,'N/A',"23-03-2010"),incerto).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% teste do documento de apoio

% e_ad(municipio_de_alto_de_basto,705330336,portugal).
% e_ada(associados_sociedade_de_advogados_sp_rl,702675112,portugal).
% contrato(1,705330336,702675112,aquisicao_de_servicos,consulta_previa,assessoria_juridica,13599,547,alto_de_basto,"11-02-2020").
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -










