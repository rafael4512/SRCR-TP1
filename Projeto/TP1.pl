%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho pratico 1-Sistema para contratação publica.

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



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariantes Estruturais e Referenciais.


% ************* Adjudicante **************************

% Garante que não é possível adicionar entidades Adjudicantes com o mesmo Nome ou  Nif. 
+e_ad(Nome,Nif,Morada) :: (findall( ( (Nome,Nif) ),(e_ad(Nome,_,_);e_ad(_,Nif,_) ), S),
                length(S,N), N == 2).







% Garante que não seja possivel a remocao de uma entidade Adjudicante
-e_ad(Nome,Nif,Morada):-
	nao(e_ad(Nome,Nif,Morada)).	

% ************* Adjudicataria **************************

%
+e_ada(Nome,Nif,Morada) :: (findall( ( (Nome,Nif) ),(e_ada(Nome,_,_);e_ada(_,Nif,_) ), S),
                length(S,N), N == 2).

-e_ada(Nome,Nif,Morada):-
	nao(e_ada(Nome,Nif,Morada)).	


% ************* Contratos **************************


% Garante que não haja contratos com o mesmo Id.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (findall(Id,contrato(Id,_,_,_,_,_,_,_,_,_),S),
                                                                              length(S,N),
                                                                               N==1).
% Garante que um contrato tem um procedimento válido.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (TipoP= ajuste_direto;TipoP= consulta_previa,TipoP= concurso_publico).


% Garante as condições impostas  por um contrato de ajuste direto.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (TipoP = ajuste_direto, 
                                                                              Custo =<   5000,  
                                                                              (TipoC=contrato_de_aquisicao;TipoC=locao_de_bens_moveis;TipoC=aquisicao_de_servicos)).



% >Garante que não é possivel adicionar um  contrato, onde  o preço contratual acumulado dos contratos já celebrados seja igual ou superior a 75.000 euros.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: ( findall( C,   contrato(_,Nif_ad,Nif_ada,TipoC,_,_,C,_,_,_), S),
                                                                                 sum_list(S,Total),
                                                                                 Total < 75000 ).









% verificaPazo(Prazo,Data,X):-
% format_time(3,"%d-%m-%Y",date(D,M,Y)).








