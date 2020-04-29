%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Funções auxiliares

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado si: Questao,Resposta -> {V,F}
%                            Resposta = { verdadeiro,falso,desconhecido,impreciso,incerto,interdito}
si( Questao,verdadeiro ) :-
    Questao.
si( Questao,falso ) :-
    -Questao.
si( Questao,R) :-
    excecao(Questao,R).
si( Questao,desconhecido ).

% si( Questao,verdadeiro ) :-
%     Questao.
% si( Questao,falso ) :-
%     -Questao.	
% si( Questao,desconhecido ) :-
%     nao( Questao ),
%     nao( -Questao ).



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
encontraAdjudicante(Nif,Ad) :- findall(e_ad(Nome,Nif,Morada),(excecao(e_ada(Nome,Nif,Morada),TX),TX \= intedito) ,Ad).  


% Encontrar uma adjudicataria por NIF.
encontraAdjudicataria(Nif,Ada) :- findall(e_ada(Nome,Nif,Morada),e_ada(Nome,Nif,Morada) ,Ada).
encontraAdjudicataria(Nif,Ada) :- findall(e_ada(Nome,Nif,Morada),(excecao(e_ada(Nome,Nif,Morada),TX),TX \= intedito) ,Ada).
                                   


% Encontrar um contrato por Id.
encontraContrato(Id,C) :- findall(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Dat),(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),atom_codes(Dat,Data)) ,C).
encontraContrato(Id,C) :- findall(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Dat),((excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),TX \= intedito),atom_codes(Dat,Data)) ,C).
                        



% Retorna todos os contratos de uma entidade adjudicante .
encontraTodosContratos(Nif,L) :- findall(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Dat),
                                 ((contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                                 (excecao(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
                                 TX \= interdito)),atom_codes(Dat,Data) ),L).

% Retorna todos os contratos de uma entidade adjudicante em vigor .
encontraTodosEmVigor(Nif,L) :- findall(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Dat),
                                 (((contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                                 (excecao(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
                                 TX \= interdito)),verificaPrazo(Data,Prazo,em_vigor)),atom_codes(Dat,Data)) ,L).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%   Calculos
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Total acumulado de uma entidade encontraAdjudicante
totalAcumulado(Nif,Tot) :- findall(Custo,(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                                         (excecao(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),TX \= intedito)) ,S),
                           sum_list(S,Tot).

% Calcular a soma dos valor dos contratos em vigor respetivos aos anos economicos recebidos como parametro, de uma certa entidade adjudicante e Adjudicataria.
% verificaPrazo 
somarContratos_Vigor(Nif_ad,Nif_ada,Anos,Total) :- findall((Data,Custo,Prazo), (contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                                                                               (excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
                                                                                TX \= interdito)),S),
                                                   map2(ano,S,Anos,X),
                                                   sum_list(X,Total).

                                                
                                             



% Calcular a soma dos valor dos contratos respetivos aos anos recebidos como parametro, de uma certa entidade adjudicante e Adjudicataria.
somarContratos(Nif_ad,Nif_ada,Anos,Total) :- findall((Data,Custo), (contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                                                                   (excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
                                                                    TX \= interdito)),S),
                                             map1(ano,S,Anos,X),
                                             sum_list(X,Total).


% Função que mapeia um tipo especifico de lista.
map1(F, [],Anos,[]).
map1(F,[(H,H1)|T],Anos,[H1|Ps]):- call(F,H,Y),x_existe_lista(Y,Anos,sim) , map1(F,T,Anos,Ps).
map1(F,[(H,H1)|T],Anos,Ps):- call(F,H,Y),x_existe_lista(Y,Anos,nao) , map1(F,T,Anos,Ps).

% Funcao usada para 
map2(F, [],Anos,[]).
map2(F,[(H,H1,H2)|T],Anos,[H1|Ps]):- call(F,H,Y),verificaPrazo(H,H2,em_vigor),x_existe_lista(Y,Anos,sim) , map2(F,T,Anos,Ps).
map2(F,[(H,H1,H2)|T],Anos,Ps):- call(F,H,Y),x_existe_lista(Y,Anos,nao) , map2(F,T,Anos,Ps).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%   TESTES
%--------------------------------- - - - - - - - - - -  -  -  -  -   -



% totalAcumulado(700000003,X).
% anosEcoData("01-01-2020",Anos).

% encontraContrato(8,R). #intedito.
% map1(ano,[("01-01-2020",12000),("01-01-2020",12000),("01-01-2020",12000)],[2020],X).
% map2(ano,[("01-01-2020",12000,365),("01-01-2020",12000,10),("01-01-2020",12000,300)],[2020],X).

% somarContratos_Vigor(700000003,_,_,Tot).


