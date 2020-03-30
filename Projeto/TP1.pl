%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho pratico 1

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ).
:- dynamic e_ad/3.

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
contrato(705330336,702675112,aquisicao_de_servicos,consulta_previa,assessoria_juridica,13599,547,alto_de_basto,"11-02-2020").



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Serve para não inserir entidades repetidas.(Nao pode haver nomes iguais nem nifs  iguais, mas pode haver moradas!)
% FEITO

% Para as  entidades ad
+e_ad(Nome,Nif,Morada) :: (findall( ( (Nome,Nif) ),(e_ad(Nome,_,_);e_ad(_,Nif,_) ), S),
                length(S,N), N == 2).

-e_ad(Nome,Nif,Morada):-
	nao(e_ad(Nome,Nif,Morada)).	

% Para as  entidades ada

+e_ada(Nome,Nif,Morada) :: (findall( ( (Nome,Nif) ),(e_ada(Nome,_,_);e_ada(_,Nif,_) ), S),
                length(S,N), N == 2).

-e_ada(Nome,Nif,Morada):-
	nao(e_ada(Nome,Nif,Morada)).	






% Testes
% evolucao(e_ad(o,705330336,ola2)).
% evolucao(e_ad(municipio_de_alto_de_basto,705330336,ola2)).
% evolucao(e_ad(municipio_de_alto_de_basto,705330331,ola2)).
% evolucao(e_ad(o2,702533032,ola2)). (Teste que tem de funcionar)
% findall((M;N),e_ad(M,N,_),S).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -










