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
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (TipoP= ajuste_direto;TipoP= consulta_previa,TipoP= concurso_publico).


% Garante as condições impostas  por um contrato de ajuste direto.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (TipoP = ajuste_direto,
                                                                              diasAno(Data,MaxDias),
                                                                              Prazo=<MaxDias,
                                                                              Custo =<   5000,  
                                                                              (TipoC=contrato_de_aquisicao;TipoC=locao_de_bens_moveis;TipoC=aquisicao_de_servicos)).



% > Regra dos 3 anos->Garante que não é possivel adicionar um  contrato, onde  o preço contratual acumulado dos contratos já celebrados seja igual ou superior a 75.000 euros.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (anosEcoData(Data,Anos), 
                                                                              somarContratos(Nif_ad,Nif_ada,Anos,Total), 
                                                                              Total < 75000 ).


% Garante que só seja possivel remover contratos celebrados no dia.
 -contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: data_Atual(Data,sim).




%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Procedimentos de evolução do conhecimento.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%************** Adicionar conhecimento ****************

% Regista uma entidade Adjudicante
novoAdjudicante(Nome,Nif,Morada) :- evolucao(e_ad(Nome,Nif,Morada)).

% Regista uma entidade Adjudicataria
novaAdjudicataria(Nome,Nif,Morada) :- evolucao(e_ada(Nome,Nif,Morada)).

% Regista um contrato
novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :- evolucao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data)).



%************** Remover conhecimento ****************

% Remove uma entidade Adjudicante.
removerAdjudicante(Nif) :- encontraAdjudicante(Nif,Ad) , involucao(Ad).

% Remove uma entidade Adjudicataria.
removerAdjudicataria(Nif) :- encontraAdjudicataria(Nif,Ada) , involucao(Ada).

% Remove um contrato.
removerContrtato(Id) :- encontraContrato(Id,C) , involucao(C).




%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

