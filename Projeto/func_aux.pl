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


% Soma os elementos da lista.
sum_list([[]],0).
sum_list([],0).
sum_list([H|T],R) :- sum_list(T,R1), R is R1+H.


% Verifica se um elemento existe na lista.
x_existe_lista(X, [],nao).
x_existe_lista(X, [X|T] ,sim). 
x_existe_lista(X, [H|T] ,R) :- x_existe_lista(X,T,R). 



      
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
%Calculos
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Calcular a soma dos valor dos contratos em vigor respetivos aos anos economicos recebidos como parametro, de uma certa entidade adjudicante e Adjudicataria.
%verificaPrazo
somarContratos(Nif_ad,Nif_ada,Anos,Total) :- findall((Data,Custo), (contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data)),S),
                                             map1(ano,S,Anos,X),
                                             sum_list(X,Total).


%Funções que mapeia um tipo especifico de lista.
map1(F, [],Anos,[]).
map1(F,[(H,H1)|T],Anos,[H1|Ps]):- call(F,H,Y),x_existe_lista(Y,Anos,sim) , map1(F,T,Anos,Ps).
map1(F,[(H,H1)|T],Anos,Ps):- call(F,H,Y),x_existe_lista(Y,Anos,nao) , map1(F,T,Anos,Ps).




% anosEcoData(Data,Anos), somarContratos(Nif_ad,Nif_ada,Anos,Tot). 
% map1(ano,[("01-01-2020",12000),("01-01-2020",12000),("01-01-2020",12000)],[2020],X).


% (705330336,702675112,anosEcoData(Data,L),Tot)
% somarContratos(705330336,702675112,[2010,2020],Tot).


