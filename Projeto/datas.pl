%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Datas 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% os dinamic é para tirar em PRICÍPIO .... TEMOS DE TESTAR !!!!!!
:- dynamic stringToNumber/2.
:- dynamic strToNum/3.
:- dynamic converterData/2.
:- dynamic conv_DateToParam/4.

:- dynamic dateToDays/4.
:- dynamic ytoDay/2.
:- dynamic mtoDay/3.
:- dynamic countmonth/3.

:- dynamic maior/3.
:- dynamic verificaPrazo/3.
:- dynamic dataEValida/3.


:- dynamic anosEcoData/2.
:- dynamic diasAno/2.
:- dynamic ano/2.



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Coverter Strings em  Datas
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%converte uma string com um digito em um inteiro.
stringToNumber("0",0).
stringToNumber("1",1).
stringToNumber("2",2).
stringToNumber("3",3).
stringToNumber("4",4).
stringToNumber("5",5).
stringToNumber("6",6).
stringToNumber("7",7).
stringToNumber("8",8).
stringToNumber("9",9).

stringToDelim(45).
stringToDelim(47).



% Verifica se a data é válida
-dataEValida(D,M,A) :- D < 1 ; D > 31.
-dataEValida(D,M,A) :- M < 1 ; M > 12.
dataEValida(D, M, A):- x_existe_lista(M, [1,3,5,7,8,10,12],sim),
				D >= 1, D < 32.
dataEValida(D, M, A):- x_existe_lista(M, [4,6,9,11],sim),
				D >= 1, D < 31.
dataEValida(D, 2, A):- A mod 4 =:= 0, D >= 1, D < 30.
dataEValida(D, 2, A):- A mod 4 =\= 0, D >= 1, D < 29.


% converte uma string(que é um numero), em um inteiro.
 strToNum([X],1,P):-stringToNumber([X],P).
 strToNum([H|T],S,R):- S2 is S-1 , 
 					   stringToNumber([H],H1),
  					   S1 is H1*(10^S2),
  					   strToNum(T,S2,AUX), 
  					   R is AUX+S1.

% Convete uma data para o formato Americano.(Y-M-D)
converterData([C0,C1,C2,C3,C4,C5,C6,C7,C8,C9],D):-  strToNum([C6,C7,C8,C9],4,R1),
													strToNum([C3,C4],2,R2),
													strToNum([C0,C1],2,R3),
													(D = date(R1,R2,R3)) .




% Converte string Data para os Dia, mes e ano .
conv_DateToParam([C0,C1,C2,C3,C4,C5,C6,C7,C8,C9],D,M,A):-strToNum([C6,C7,C8,C9],4,A),
													     strToNum([C3,C4],2,M),
													     strToNum([C0,C1],2,D),
													     dataEValida(D,M,A),!,
													     stringToDelim(C2),
													     stringToDelim(C5).
													   
conv_DateToParam([C1,C2,C3,C4,C5,C6,C7,C8,C9],D,M,A):-strToNum([C6,C7,C8,C9],4,A),
													     strToNum([C3,C4],2,M),
													     strToNum([C1],1,D),
													     dataEValida(D,M,A),!,
													     stringToDelim(C2),
													     stringToDelim(C5).

conv_DateToParam([C0,C1,C2,C4,C5,C6,C7,C8,C9],D,M,A):-strToNum([C6,C7,C8,C9],4,A),
													     strToNum([C4],1,M),
													     strToNum([C0,C1],2,D),
													     dataEValida(D,M,A),!,
													     stringToDelim(C2),
													     stringToDelim(C5).

conv_DateToParam([C1,C2,C4,C5,C6,C7,C8,C9],D,M,A):-strToNum([C6,C7,C8,C9],4,A),
													     strToNum([C4],1,M),
													     strToNum([C1],1,D),
													     dataEValida(D,M,A),!,
													     stringToDelim(C2),
													     stringToDelim(C5).

% Obtem a data atual.
curdate(D1,M1,A1):- datime(datime(A1,M1,D1,_,_,_)).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Predicados para converter tudo para dias
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Converte uma data para dias.
dateToDays(D,M,A,Days):-  Bissexto is mod(A,4),
						  ytoDay(A,R2), 
 						  countmonth(Bissexto,M,R1), 
 						  Days is D+R1+R2.





% Converte anos para dias. Estou a partir 1-1-0001. 
ytoDay(Y,D):- Y1 is Y - 1, 
			  X is div(Y1,4),
			  X1 is Y1 - X,
			  D is X*366 + X1*365.




% Dado um Mes  diz-nos quandos dias tem. mtoDay(anoBissextoFLAG, MES, DIAS)
mtoDay(_,1,31).
mtoDay(0,2,29).
mtoDay(_,2,28).
mtoDay(_,3,31).
mtoDay(_,4,30).
mtoDay(_,5,31).
mtoDay(_,6,30).
mtoDay(_,7,31).
mtoDay(_,8,31).
mtoDay(_,9,30).
mtoDay(_,10,31).
mtoDay(_,11,30).
mtoDay(_,12,31).
mtoDay(_,_,0).


% Incrementa o numero de dias dado um mes .Por exemplo, no mês de março aindo só passaram os dias de janeiro e fevereiro.
countmonth(X,0,0).
countmonth(X,M,R) :-M1 is M-1 ,
					mtoDay(X,M1,P),
					countmonth(X,M1,AUX),
					R is P+AUX.






%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Comparar Datas
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Seve de função auxiliar para saber se um contrato está caducado ou não.
maior(X,Y,em_vigor):- X >= Y .
maior(X,Y,caducado):- X < Y .





%verifica o prazo de um contrato.Se um contrato tem 
verificaPrazo(Data,Prazo,Res):-  conv_DateToParam(Data,D,M,A), 
	  					  		 dateToDays(D,M,A,Days),
	  					  		 R1 is Days +Prazo,
	  					         curdate(D1,M1,S1),
						         dateToDays(D1,M1,S1,Days2),!,
						         maior(R1,Days2,Res).
						  



% verificaPrazo("31-01-2020",10,R). 
% verificaPrazo("31-01-2020",10,em_vigor).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Consultar Datas
%--------------------------------- - - - - - - - - - -  -  -  -  -   -


% Dado uma data saber o ano económico em curso e nos dois anos económicos anteriores.

anosEcoData([C0,C1,C2,C3,C4,C5,C6,C7,C8,C9],A):-  strToNum([C6,C7,C8,C9],4,R),
											  R1 is R-1,R2 is R-2,
											  A =[R2,R1,R].


%Dado uma data, saber quantos dias tem o corresponde ano.(#365, ou #366).

diasAno([C0,C1,C2,C3,C4,C5,C6,C7,C8,C9],Dias):- strToNum([C6,C7,C8,C9],4,R1), 
											     R is mod(R1,4),
											     ((R = 0,Dias=366); Dias=365).


%Ano de uma data.
ano([C0,C1,C2,C3,C4,C5,C6,C7,C8,C9],A):- strToNum([C6,C7,C8,C9],4,A).




%Verifica se uma data é o dia atual.

data_Atual(Data,sim):-conv_DateToParam(Data,D,M,A), curdate(D,M,A).
data_Atual(_,nao).
% -data_Atual(_,nao).



