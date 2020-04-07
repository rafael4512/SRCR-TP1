%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Funções auxiliares

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



% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado evolucao e involucao.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
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
% Listas
%--------------------------------- - - - - - - - - - -  -  -  -  -   -



% Soma de listas
sum_list(Xs, Sum) :-
      sum_list(Xs, 0, Sum).
  
sum_list([], Sum, Sum).
sum_list([X|Xs], Sum0, Sum) :-
      Sum1 is Sum0 + X,
      sum_list(Xs, Sum1, Sum).



      
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Pesquisa na base de conhecimento.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Encontrar um adjudicante dado o NIF.
encontraAdjudicante(Nif,Ad) :- findall(e_ad(Nome,Nif,Morada),e_ad(Nome,Nif,Morada) ,Ad).


% Encontrar uma adjudicataria por NIF.
encontraAdjudicataria(Nif,Ada) :- findall(e_ada(Nome,Nif,Morada),e_ada(Nome,Nif,Morada) ,Ada).


% Encontrar um contrato por Id.
encontraContrato(Id,C) :- findall(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) ,C).






     














     
%--------------------------------- - - - - - - - - - -  -  -  -  -   -



