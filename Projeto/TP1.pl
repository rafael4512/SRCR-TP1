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
:- dynamic jogo/3.

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
% Base de conhecimento
% e_ad = Entidade Adjudicante (Ex:Uma empresa a querer contratar)
% e_ada = Entidade Adjudicatária (Ex:o contratado)
 

e_ad(municipio_de_alto_de_basto,705330336,portugal).
e_ada(associados_sociedade_de_advogados_sp_rl,702675112,portugal).
contrato(705330336,702675112,aquisicao_de_servicos,consulta_previa,assessoria_juridica,13599,547,alto_de_basto,"11-02-2020").
