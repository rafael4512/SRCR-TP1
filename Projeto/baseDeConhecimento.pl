%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de conhecimento
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% e_ad = Entidade Adjudicante    - Uma empresa pública que quer contratar,(Ex:CP)
% e_ada = Entidade Adjudicatária - A empresa contratada,(Ex:GALP)
 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Entidades Adjudicante(Nome,Nif,Morada) ->{V,F}
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% e_ad('CP – Comboios de Portugal',700000000,'Portugal').
% e_ad('BRISA - Autoestradas de Portugal, S.A.',700000001,'Portugal').
% e_ad('NAV Portugal, EPE',700000003,'Portugal').
% e_ad('ULSAM - Unidade Local de Saúde do Alto Minho, EPE',700000004,'Portugal').
% e_ad('CGD - Caixa Geral de Depósitos, SA',700000005,'Portugal').
% e_ad('PME Investimentos - Sociedade de Investimentos, SA',700000006,'Portugal').


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Entidades adjudicatária(Nome,Nif,Morada) ->{V,F}
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% e_ada('PETROGAL, S.A',300000000,'Portugal').
% e_ada('EDP',300000001,'Portugal').
% e_ada('Pingo Doce',300000002,'Portugal').
% e_ada('TAP',300000003,'Portugal').
% e_ada('GALP',300000004,'Portugal').
% e_ada('CTT',300000005,'Portugal').
% e_ada('PRIO SUPPLY, S.A.',300000006,'Portugal').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Contratos (ID,NifAd, NifAda, TipoDeContrato, TipoDeProcedimento, Descrição, Valor, Prazo, Local, Data ) -> {V,F}
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% contrato(1,700000000,300000000,'Aquisição de Serviços','Consulta Previa','Fornecimento de petrólio',50000,365,'Lisboa',"01-01-2020"). % CP-PETROGAL
% contrato(2,700000000,700000005,'Aquisição de Serviços','Ajuste Direto','contrato de intermediação financeira',25000,366,'Lisboa',"01-01-2020"). % CP-CGD
% contrato(3,700000001,300000006,'Aquisição de Serviços','Concurso Público','Controlo das portagens ',100000,365,'Lisboa',"06-01-2020"). % BRISA-PRIO


%PRECISAM DE SER AJEITADOS ... 
% contrato(4,700000004,300000001,'Aquisição de Serviços','Concurso Público','Controlo das portagens ',100000,365,'Lisboa',"06-01-2020"). % ULSAM-EDP
% contrato(5,700000004,300000004,'Aquisição de Serviços','Concurso Público','Controlo das portagens ',100000,365,'Lisboa',"06-01-2020"). % ULSAM-GALP
% contrato(6,700000003,300000003,'Aquisição de Serviços','Concurso Público','Controlo das portagens ',100000,365,'Lisboa',"06-01-2020"). % NAV-TAP
% contrato(7,700000006,300000005,'Aquisição de Serviços','Concurso Público','Controlo das portagens ',100000,365,'Lisboa',"06-01-2020"). % PME-CTT

% contrato(8,700000006,700000004,'Locação de bens móveis','Ajuste Direto','Compra de luvas',5000,30,'Lisboa',"01-02-2020"). % PME-ULSAM





% https://www.topster.pt/calendario/tagerechner.php
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Pequeno exemplo de teste.

e_ad(municipio_de_alto_de_basto,705330336,portugal).
e_ada(associados_sociedade_de_advogados_sp_rl,702675112,portugal).
contrato(1,705330336,702675112,aquisicao_de_servicos,consulta_previa,assessoria_juridica,13599,547,alto_de_basto,"11-02-2020").








%--------------------------------- - - - - - - - - - -  -  -  -  -   -