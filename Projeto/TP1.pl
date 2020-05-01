%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho pratico 1-Sistema para contratação publica.



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%Modulo para obter o dia da maquina.
:- use_module(library(system), 
        [datime/1,now/1]).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%-------


:- op( 900,xfy,'::' ).
:- dynamic e_ad/3.
:- dynamic e_ada/3.
:- dynamic contrato/10.
:- dynamic excecao/2.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Load dos ficheiros

:- include('func_aux.pl').
:- include('baseDeConhecimento.pl').
:- include('datas.pl').


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariantes Estruturais e Referenciais.


% ************* Adjudicante **************************

% Garante que não é possível adicionar entidades Adjudicantes com o mesmo Nome ou  Nif. 
+e_ad(Nome,Nif,Morada) :: (findall( ( (Nome,Nif) ),(e_ad(Nome,_,_);e_ad(_,Nif,_) ), S),
                length(S,N), N == 2).


% Garante que não seja possivel a remocao de uma entidade Adjudicante com contrato celebrados.
-e_ad(Nome,Nif,Morada) :: (findall(Id,contrato(Id,_,Nif,_,_,_,_,_,_,_),S),
                          length(S,0)).




% ************* Adjudicataria **************************

% Garante que insere  uma entidade Adjudicataria com um nif e nome diferente das existentes.
+e_ada(Nome,Nif,Morada) :: (findall( ( (Nome,Nif) ),(e_ada(Nome,_,_);e_ada(_,Nif,_) ), S),
                length(S,N), N == 2).


% Garante que não remove entidades Adjudicataria que tem contratos celebrados.
-e_ada(Nome,Nif,Morada) :: (findall(Id,contrato(Id,_,Nif,_,_,_,_,_,_,_),S),
                          length(S,0)).






% ************* Contratos **************************


% Garante que não haja contratos com o mesmo Id.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (findall(Id,contrato(Id,_,_,_,_,_,_,_,_,_),S),
                                                                              length(S,N),
                                                                               N==1).
% Garante que um contrato tem um procedimento válido.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (TipoP= 'Ajuste Direto';TipoP= 'Consulta Previa';TipoP='Concurso Publico').

% Garante as condições impostas  por um contrato de ajuste direto.
+contrato(Id,Nif_ad,Nif_ada,TipoC,'Ajuste Direto',Descricao,Custo,Prazo,Local,Data) ::( 
                                                                               diasAno(Data,MaxDias),
                                                                               Prazo=<MaxDias,
                                                                               Custo =<   5000,  
                                                                               (TipoC='Contrato De Aquisicao';TipoC='Locacao de bens moveis';TipoC='Aquisicao de Servicos')).



% > Regra dos 3 anos->Garante que não é possivel adicionar um  contrato, onde  o preço contratual acumulado dos contratos já celebrados seja igual ou superior a 75.000 euros.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: ( anosEcoData(Data,Anos), 
                                                                               somarContratos(Nif_ad,Nif_ada,Anos,Total),!,
                                                                               Total-Custo < 75000).
                                                                               
                                                                       


% Garante que só seja possivel remover contratos celebrados no dia. % Deveria ser os contratos inseridos no dia.
%-contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: data_Atual(Data,sim).




%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Procedimentos de evolução do conhecimento Perfeito.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%************** Adicionar conhecimento Perfeito ****************

% Regista uma entidade Adjudicante
novoAdjudicante(Nome,Nif,Morada) :- evolucao(e_ad(Nome,Nif,Morada)).

% Regista uma entidade Adjudicataria
novoAdjudicataria(Nome,Nif,Morada) :- evolucao(e_ada(Nome,Nif,Morada)).

% Regista um contrato
novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :- evolucao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data)).



%************** Remover conhecimento Perfeito ****************
%CORRIGIR
% Remove uma entidade Adjudicante.
removerAdjudicante(Nif) :- encontraAdjudicante(Nif,Ad) , involucao(Ad).

% Remove uma entidade Adjudicataria.
removerAdjudicataria(Nif) :- encontraAdjudicataria(Nif,Ada) , involucao(head(Ada)).

% Remove um contrato.
removerContrato(Id) :- encontraContrato(Id,C) , involucao(C).






%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Procedimentos de evolução do conhecimento Imperfeito.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% ************* Adjudicante **************************
novoAdjudicante(Nome,Nif):- encontraEntidade(Nif,[]), evolucao(excecao(e_ad(Nome,Nif,'N/A'),incerto)).

novoAdjudicante(Nome,Nif,Morada,interdito):- encontraEntidade(Nif,[]), evolucao(excecao(e_ad(Nome,Nif,Morada),interdito)).

novoAdjudicante(Nome,Nif,Morada,impreciso):- encontraEntidade(Nif,[]), evolucao(excecao(e_ad(Nome,Nif,Morada),impreciso)).

% ************* Adjudicataria **************************
novoAdjudicataria(Nome,Nif):- encontraEntidade(Nif,[]), evolucao(excecao(e_ada(Nome,Nif,'N/A'),incerto)).

novoAdjudicataria(Nome,Nif,Morada,interdito):- encontraEntidade(Nif,[]), evolucao(excecao(e_ada(Nome,Nif,Morada),interdito)).

novoAdjudicataria(Nome,Nif,Morada,impreciso):- encontraEntidade(Nif,[]), evolucao(excecao(e_ada(Nome,Nif,Morada),impreciso)).

% ************* Contratos **************************




novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,interdito):- encontraContrato(Id,[]), 
  evolucao(excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),interdito)).






%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Procedimentos de substituição do conhecimento ImPerfeito.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%Só se substui por conhecimento perfeito

subsE_ad(Nome,Nif,Morada):- findall(excecao(e_ad(Nome,Nif,M),P),excecao(e_ad(Nome,Nif,M),P),S),
                            length(S,1),
                            involucao(excecao(e_ad(Nome,Nif,M),P)),
                            novoAdjudicante(Nome,Nif,Morada).

subsE_ada(Nome,Nif,Morada):- findall(excecao(e_ada(Nome,Nif,M),P),excecao(e_ada(Nome,Nif,M),P),S),
                            length(S,1),
                            involucao(excecao(e_ada(Nome,Nif,M),P)),
                            novoAdjudicataria(Nome,Nif,Morada).



% subsContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data):-


% findall(excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
%    excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),S),






% (excecao(e_ad(_,Nif,_),_);) 



%findall(('Municipio de Moncao, S.A',700000007),  (excecao(e_ad(_,700000007,_),_) ; excecao(e_ad('Municipio de Moncao, S.A',_,_),_)  ),S).

%Dá Yes se existir essa excecao!
encontrarExcecoes_ad(Nome,Nif) :- findall((Nome,Nif),excecao(e_ad(Nome,Nif,_),_),S),  length(S,1). 

% verificarExcecoes_ad('Municipio de Moncao, S.A',700000007);verificarExcecoes_ad('Municipio de Moncao, S.A',1).;verificarExcecoes_ad('Municipio de Moncao, S.1',3).


% verificarExcecoes_ada()

% verificarExcecoes_contra()





%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Testes .
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Invariantes do ajuste direto Respeitado.
% evolucao(contrato(20,700000000,700000005,'Aquisicao de Servicos','Ajuste Direto','contrato de intermediação financeira',5000,365,'Lisboa',"01-04-2019")).
% -*-


% 
% evolucao(contrato(60,700000003,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',5000000,1096,'Lisboa',"06-01-2020")).


% Mostra o resultado do Invariante da regra dos 3 anos.
% somarContratos(700000003,300000003,[2018,2019,2020],Tot).
% evolucao(contrato(61,700000003,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',69999,1096,'Lisboa',"07-01-2020")).
% evolucao(contrato(62,700000003,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',1,1096,'Lisboa',"07-01-2020")).
% evolucao(contrato(63,700000003,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',1,1096,'Lisboa',"07-01-2020")). 
% -*-




% Teste para provar como substitui o conhecimento imPerfeito para perfeito no caso dos Adjudicantes.
% novoAdjudicante('Costa',123).
% encontraAdjudicante(123,C).
% subsE_ad('Costa',123,'R da cruz B1 N90, Porto').
% encontraAdjudicante(123,C).
% e_ad('Costa',123,'N/A').
% -*-





















