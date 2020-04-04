%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de conhecimento
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% e_ad = Entidade Adjudicante (Ex:Uma empresa publica que quer contratar,CP)
% e_ada = Entidade Adjudicatária (Ex:a empresa contratada, GALP)
 

%Entidades Adjudicante(Nome,Nif,Morada) ->{V,F}


% e_ad('CP – Comboios de Portugal',700000000,portugal).
% e_ad('BRISA - Autoestradas de Portugal, S.A.',700000001,portugal).
% e_ad('NAV Portugal, EPE',700000003,portugal).
% e_ad('ULSAM - Unidade Local de Saúde do Alto Minho, EPE',700000004,portugal).
% e_ad('CGD - Caixa Geral de Depósitos, SA',700000005,portugal).
% e_ad('PME Investimentos - Sociedade de Investimentos, SA',700000006,portugal).
% 
% 
% 
% 
% 
% %Entidades adjudicatária(Nome,Nif,Morada) ->{V,F}
% e_ada('PETROGAL, S.A',300000000,portugal).
% e_ada('EDP',300000001,portugal).
% e_ada('Pingo Doce',300000002,portugal).
% e_ada('TAP',300000003,portugal).
% e_ada('GALP',300000004,portugal).
% e_ada('CTT',300000005,portugal).
% e_ada('PRIO SUPPLY, S.A.',300000006,portugal).


% Contratos (ID,NifAd, NifAda, TipoDeContrato, TipoDeProcedimento, Descrição, Valor, Prazo, Local, Data ) -> {V,F}


e_ad(municipio_de_alto_de_basto,705330336,portugal).
e_ada(associados_sociedade_de_advogados_sp_rl,702675112,portugal).
contrato(1,705330336,702675112,aquisicao_de_servicos,consulta_previa,assessoria_juridica,13599,547,alto_de_basto,'11-02-2020').








%--------------------------------- - - - - - - - - - -  -  -  -  -   -