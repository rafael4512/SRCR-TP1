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
sum_list(['N/A'|T],R) :- sum_list(T,R). 
sum_list([H|T],R) :- sum_list(T,R1), R is R1+H.


% Verifica se um elemento existe na lista.
x_existe_lista(X, [],nao).
x_existe_lista(X, [X|T] ,sim). 
x_existe_lista(X, [H|T] ,R) :- x_existe_lista(X,T,R). 



      
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Pesquisa na base de conhecimento.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -


% Encontrar um adjudicante dado o NIF.
encontraAdjudicante(Nif,Ad) :- findall(e_ad(Nome,Nif,Morada),
                                      (e_ad(Nome,Nif,Morada);(excecao(e_ad(Nome,Nif,Morada),TX),TX \= interdito) ),
                                       Ad).


% Encontrar uma adjudicataria por NIF.
encontraAdjudicataria(Nif,Ada) :- findall(e_ada(Nome,Nif,Morada),
                                  (e_ada(Nome,Nif,Morada);(excecao(e_ada(Nome,Nif,Morada),TX),TX \= interdito)),
                                  Ada).

% Encontra apenas excecões de entidades adjudicantes.
encontraAdjudicante2(Nif,Ad) :- findall(excecao(e_ad(Nome,Nif,Morada),TX),
                                        excecao(e_ad(Nome,Nif,Morada),TX),
                                        Ad).

% Encontra apenas excecões de entidades adjudicatarias.
encontraAdjudicataria2(Nif,Ada) :- findall(excecao(e_ada(Nome,Nif,Morada),TX),
                                          excecao(e_ada(Nome,Nif,Morada),TX),
                                          Ada).



% Encontrar um contrato por Id.
encontraContrato(Id,C) :- findall(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Dat),
                          ( (contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                            (excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),TX \= interdito)),
                            atom_codes(Dat,Data)),
                            C).
encontraContrato2(Id,C) :- findall(excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
                            excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
                            C).


     

%Encontrar uma entidade adjudicante ou adjudicataria.
encontraEntidade(Nif ,S) :- findall( Nome ,
                             (((excecao(e_ada(Nome,Nif,Morada),TX),TX \= interdito);(excecao(e_ad(Nome,Nif,Morada),TX),TX \= interdito)); 
                             (e_ad(Nome,Nif,Morada);e_ada(Nome,Nif,Morada)) ),
                             S).




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


% Encontra todos os contratos em vigor ou caducados acima de um certo valor.
encontraTodosConAcimaDe(Val,em_vigor,L) :- findall(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Dat),
                                        ( (contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                                 (excecao(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
                                 TX \= interdito)),Custo >= Val,verificaPrazo(Data,Prazo,em_vigor),atom_codes(Dat,Data)) ,L).
encontraTodosConAcimaDe(Val,caducado,L) :- findall(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Dat),
                                        ( (contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                                 (excecao(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
                                 TX \= interdito)),Custo >= Val,verificaPrazo(Data,Prazo,caducado),atom_codes(Dat,Data)) ,L).





% Encontra apenas as excecões de entidades adjudicantes.
encontraAdjudicanteImp(Nif,Ad):-findall(excecao(e_ad(Nome,Nif,Morada),TX),
                                    excecao(e_ad(Nome,Nif,Morada),TX),
                                       Ad).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%   Calculos
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Total acumulado de uma entidade adjudicante.
totalAcumulado(Nif,Tot) :- findall(Custo,(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                                         (excecao(contrato(Id,Nif,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),TX \= interdito)) ,S),
                           sum_list(S,Tot).

% Calcular a soma dos valor dos contratos em vigor respetivos aos anos economicos recebidos como parametro, de uma certa entidade adjudicante e Adjudicataria. 
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


% Função que mapeia um tipo especifico de lista executa um filtro especifico.
map1(F, [],Anos,[]).
map1(F,[(H,H1)|T],Anos,[H1|Ps]):- call(F,H,Y),x_existe_lista(Y,Anos,sim) , map1(F,T,Anos,Ps).
map1(F,[(H,H1)|T],Anos,Ps):- call(F,H,Y),x_existe_lista(Y,Anos,nao) , map1(F,T,Anos,Ps).

% Funcao que mapeia uma lista e executa um filtro especifico.
map2(F, [],Anos,[]).
map2(F,[(H,H1,H2)|T],Anos,[H1|Ps]):- call(F,H,Y),verificaPrazo(H,H2,em_vigor),x_existe_lista(Y,Anos,sim) , map2(F,T,Anos,Ps).
map2(F,[(H,H1,H2)|T],Anos,Ps):- call(F,H,Y),x_existe_lista(Y,Anos,nao) , map2(F,T,Anos,Ps).

% Map tradicional onde se aplica a função ao primeiro elemento do par.
map3(F, [],[]).
map3(F,[(H,H1)|T],[(Y,H1)|Ps]):- call(F,H,Y), map3(F,T,Ps).
map3(F,[(H,H1)|T],Ps):- call(F,H,Y), map3(F,T,Ps).




%Retorna as entidades por ordem decrescente relativamente ao valor acumulado nos contratos celebrados.
topEntidadesAd(S1) :- findall((Nif_ad,Custo), (contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                                           (excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
                                           TX \= interdito)),S),
                                            juntarpares(S,S,S2),
                                            map3(encontraEntidade,S2,S1).

                           
%Junta, se o segundo elemento do par for igual. 
juntapar((X,Y),[],[(X,Y)]).
juntapar((X,Y),[(X,Y1)|T1],[(X,Y2)|T1]):-  Y2 is Y1 + Y.
juntapar((X,Y),[(X1,Y1)|T1],L):- juntapar((X,Y),T1,L2),append([(X1,Y1)],L2,L). 

% Junta todos os pares repetidos e ordena-os.
juntarpares([],L,L1):- qsort(L,[],L1).
juntarpares([(X,Y)|T],[(X1,Y1)|T1],L):-juntapar((X1,Y1),T1,L1),juntarpares(T,L1,L).
 


% Insere ordenado, numa lista ordenada.
insereOdenado((X,Y),[],[(X,Y)]).
insereOdenado((X,Y),[(X1,Y1)|L],P) :- Y>=Y1,append([(X,Y)],[(X1,Y1)|L],P).
insereOdenado((X,Y),[(X1,Y1)|L],P) :- Y<Y1, insereOdenado((X,Y),L,P1), append([(X1,Y1)],P1,P).


% Especie de quicksort.
qsort([],L,L).
qsort([(X,Y)|T],L1,R) :- insereOdenado((X,Y),L1,L2),qsort(T,L2,R).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%   Id Auto
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%Predicado que devolve o proximo id a inserir.
encontraMaior(ID) :- findall(Id,
                          ((contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data);
                          (excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),TX \= interdito))),
                          L), maior(L,ID).
%Retorna o maior elemento da lista e incrementa-o.      
maior([],1).
maior([H],H1) :-  H1 is H + 1.
maior([F,S|T], R) :- F > S, maior([F|T],R).
maior([F,S|T], R) :- F =< S, maior([S|T],R).

%>
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%   TESTES
%--------------------------------- - - - - - - - - - -  -  -  -  -   -


% topEntidadesAd(S).
% encontraAdjudicante(700000007,R). % encontraAdjudicante(700000000,R).
% encontraAdjudicataria(300000007,R).  
% qsort([(pl,3),(pl1,4),(pl2,1),(pl66,12),(pl6,5)],[],R).
% juntapar((pl2,2),[(pl,1),(pl1,2),(pl2,3)],R).
% juntarpares([(pl2,2),(pl,1),(pl1,2),(pl2,3),(pLL3,3),(pl2,2),(pl,1),(pl1,2),(pl2,3),(pLL3,3),(pl2,2),(pl,1),(pl1,2),(pl2,3),(pLL3,3)],[(pl2,2),(pl,1),(pl1,2),(pl2,3),(pLL3,3),(pl2,2),(pl,1),(pl1,2),(pl2,3),(pLL3,3),(pl2,2),(pl,1),(pl1,2),(pl2,3),(pLL3,3)],R).
% insereOdenado((ola,2),[(pl,1),(pl1,2),(pl2,3)],R).
% encontraTodosConAcimaDe(10,em_vigor,L).
% totalAcumulado(700000003,X).
% anosEcoData("01-01-2020",Anos).
% encontraContrato(8,R). #interdito.
% map1(ano,[("01-01-2020",12000),("01-01-2020",12000),("01-01-2020",12000)],[2020],X).
% map3(encontraEntidade,[(700000003,5008000),(700000005,5000000),(700000004,130000),(700000001,100000),(700000000,75000),(700000006,50000)],R).
% map2(ano,[("01-01-2020",12000,365),("01-01-2020",12000,10),("01-01-2020",12000,300)],[2020],X).
% somarContratos_Vigor(700000003,_,_,Tot).


