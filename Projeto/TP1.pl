%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho pratico 1-Sistema para contratação publica.


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Modulos
% :- use_module(library(lists)).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ).
:- dynamic e_ad/3.
:- dynamic e_ada/3.
:- dynamic contrato/10.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado si: Questao,Resposta -> {V,F}
%                            Resposta = { verdadeiro,falso,desconhecido }

si( Questao,verdadeiro ) :-
    Questao.
si( Questao,falso ) :-
    -Questao.	
si( Questao,desconhecido ) :-
    nao( Questao ),
    nao( -Questao ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado evolucao e involucao.

evolucao( Termo ) :-
    findall( Invariante,+Termo::Invariante,Lista ),
    insercao( Termo ),
    teste( Lista ).



involucao( Termo ) :-
    findall( Invariante,-Termo::Invariante,Lista ),
    remocao( Termo ),
    teste( Lista ).


teste( [] ).
teste( [R|LR] ) :-
    R,
    teste( LR ).

insercao( Termo ) :-
    assert( Termo ).
insercao( Termo ) :-
    retract( Termo ), !,fail.
	


remocao( Termo ) :-
    retract( Termo ).
remocao( Termo ) :-
    assert( Termo ),!,fail.





%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de conhecimento
% e_ad = Entidade Adjudicante (Ex:Uma empresa a querer contratar)
% e_ada = Entidade Adjudicatária (Ex:o contratado)
 

e_ad(municipio_de_alto_de_basto,705330336,portugal).
e_ada(associados_sociedade_de_advogados_sp_rl,702675112,portugal).
contrato(1,705330336,702675112,aquisicao_de_servicos,consulta_previa,assessoria_juridica,13599,547,alto_de_basto,"11-02-2020").
% meter ID no contratato.


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

% Garante que não é possivel adicionar um  contrato, onde  o preço contratual acumulado dos contratos já celebrados seja igual ou superior a 75.000 euros.
%Falta  fazer o verificar prazo
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: ( findall( C,   contrato(_,Nif_ad,Nif_ada,TipoC,_,_,C,_,_,_), S),
                                                                                 sum_list(S,Total),
                                                                                 Total < 75000 ).









% verificaPazo(Prazo,Data):-
% format_time(3,"%d-%m-%Y",date(D,M,Y)).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Funçoes AUXILIARES 



% Soma de listas
sum_list(Xs, Sum) :-
      sum_list(Xs, 0, Sum).
  
sum_list([], Sum, Sum).
sum_list([X|Xs], Sum0, Sum) :-
      Sum1 is Sum0 + X,
      sum_list(Xs, Sum1, Sum).









