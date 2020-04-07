%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Datas 
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



% converte uma string(que é um numero), em um inteiro.
strToNum([],0,X1).
strToNum([X],1,P):-	stringToNumber([X],P),strToNum([],0,P).
strToNum([H|T],S,R):-  S2 is S-1 , 
					   stringToNumber([H],H1),
 					   S1 is H1*10^S2 ,
 					   strToNum(T,S2,AUX), 
 					   R is AUX+S1.	


% Convete uma data para o formato Americano.(Y-M-D)

converterData([],D).
converterData([C0,C1,C2,C3,C4,C5,C6,C7,C8,C9],D):-  strToNum([C6,C7,C8,C9],4,R1),
													strToNum([C3,C4],2,R2),
													strToNum([C0,C1],2,R3),
													converterData([],date(R1,R2,R3)).






%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Predicados para converter tudo para dias
%--------------------------------- - - - - - - - - - -  -  -  -  -   -


dateToDays(D,M,A,Days):-  Bissexto is mod(A,4),
						  ytoDay(A,R2), 
 						  mtoDay(Bissexto,M,R1), 
 						  Days is D+R1+R2.


%anos para dias
ytoDay(Y,D):- X is div(Y,4),
			 X1 is Y - X,
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



















% converterData("01-02-2020",X).

% date(2021,2,1).



