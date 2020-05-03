%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho pratico 1-Sistema para contratação publica.



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%Modulo para obter o dia da maquina.
:- use_module(library(system), 
        [datime/1,now/1]).


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
:- dynamic excecao/2.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Load dos ficheiros

:- include('func_aux.pl').
:- include('baseDeConhecimento.pl').
:- include('datas.pl').


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariantes Estruturais e Referenciais.


% ************* Universais **************************

%Garante que não se insere conhecimento positivo repetido.
+P :: (findall(P, P, L),
      length(L,1)).

%Garante que não se insere conhecimento negativo repetido.
+(-P) :: (findall(P, -P, L),
         length(L,1)).

%Garante que não se insere conhecimento positivo contraditório.
+P :: nao(-P).

%Garante que não se insere conhecimento negativo contraditório.
+(-P) :: nao(P).


% ************* Adjudicante **************************

% Garante que não é possível adicionar entidades Adjudicantes com o mesmo Nome ou  Nif. 
+e_ad(Nome,Nif,Morada) :: (findall( ( (Nome,Nif) ),(e_ad(Nome,_,_);e_ad(_,Nif,_) ), S),
                length(S,N), N == 2).


% Garante que não seja possivel a remocao de uma entidade Adjudicante com contrato celebrados.
-e_ad(Nome,Nif,Morada) :: (findall(Id,contrato(Id,_,Nif,_,_,_,_,_,_,_),S),
                          length(S,0)).




% ************* Adjudicataria **************************

% Garante que insere  uma entidade Adjudicataria com um nif e nome diferente das existentes.
+e_ada(Nome,Nif,Morada) :: (findall( ( (Nome,Nif) ),(e_ada(Nome,_,_);e_ada(_,Nif,_) ), S),
                length(S,N), N == 2).


% Garante que não remove entidades Adjudicataria que tem contratos celebrados.
-e_ada(Nome,Nif,Morada) :: (findall(Id,contrato(Id,_,Nif,_,_,_,_,_,_,_),S),
                          length(S,0)).






% ************* Contratos **************************


% Garante que não haja contratos com o mesmo Id.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (findall(Id,contrato(Id,_,_,_,_,_,_,_,_,_),S),
                                                                              length(S,N),
                                                                               N==1).
% Garante que um contrato tem um procedimento válido.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (TipoP= 'Ajuste Direto';TipoP= 'Consulta Previa';TipoP='Concurso Publico').


% Garante as condições impostas  por um contrato de ajuste direto.
+contrato(Id,Nif_ad,Nif_ada,TipoC,'Ajuste Direto',Descricao,Custo,Prazo,Local,Data) ::( 
                                                                               diasAno(Data,MaxDias),
                                                                               Prazo=<MaxDias,
                                                                               Custo =<   5000,  
                                                                               (TipoC='Contrato De Aquisicao';TipoC='Locacao de bens moveis';TipoC='Aquisicao de Servicos')).



% > Regra dos 3 anos->Garante que não é possivel adicionar um  contrato, onde  o preço contratual acumulado dos contratos já celebrados seja igual ou superior a 75.000 euros.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: ( anosEcoData(Data,Anos), 
                                                                               somarContratos(Nif_ad,Nif_ada,Anos,Total),!,
                                                                               Total-Custo < 75000).
                                                                               
                                                                       


% Garante que as entidades inseridas no contrato existem.
+contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: (encontraAdjudicante(Nif_ad,[L]), encontraAdjudicataria(Nif_ada, [L1])).





% Garante que só seja possivel remover contratos celebrados no dia. % Deveria ser os contratos inseridos no dia.
%-contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :: data_Atual(Data,sim).



%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Procedimentos de evolução do conhecimento Perfeito.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%************** Adicionar conhecimento Perfeito ****************

% Regista uma entidade Adjudicante
novoAdjudicante(Nome,Nif,Morada) :- evolucao(e_ad(Nome,Nif,Morada)).

% Regista uma entidade Adjudicataria
novoAdjudicataria(Nome,Nif,Morada) :- evolucao(e_ada(Nome,Nif,Morada)).

% Regista um contrato
novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data) :- encontraMaior(Id1), evolucao(contrato(Id1,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data)),write('ID:'),write(Id1).



%************** Remover conhecimento Perfeito ****************

% Remove uma entidade Adjudicante.
removerAdjudicante(Nif) :- encontraAdjudicante(Nif,[L|T]) , involucao(L).

% Remove uma entidade Adjudicataria.
removerAdjudicataria(Nif) :- encontraAdjudicataria(Nif,[L|T]) , involucao(L).

% Remove um contrato.
removerContrato(Id) :- encontraContrato(Id,[L|T]) , involucao(L).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariantes para o conhecimento Imperfeito.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Garante que não haja contratos com o mesmo Id.
+excecao(contrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),X) :: (findall(Id,excecao(contrato(Id,_,_,_,_,_,_,_,_,_),_),S),
                                                                                        length(S,N),
                                                                                        N==1).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Procedimentos de evolução do conhecimento Imperfeito.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% ************* Adjudicante **************************
% Adicionar conhecimento imperfeito incerto referente a entidade adjudicante
novoAdjudicante(Nome,Nif,Morada,incerto):- processa(Morada,R),evolucao(excecao(e_ad(Nome,Nif,R),incerto)).

% Adicionar conhecimento imperfeito imperfeito referente a entidade adjudicante
novoAdjudicante(Nome,Nif,Morada,impreciso):- processa(Morada,R),evolucao(excecao(e_ad(Nome,Nif,R),impreciso)).

% Adicionar conhecimento imperfeito interdito referente a entidade adjudicante
novoAdjudicante(Nome,Nif,Morada,interdito):- evolucao(excecao(e_ad(('I',Nome),('I',Nif),Morada),interdito)),processa(Morada,R),evolucao(excecao(e_ad(Nome,Nif,R),interdito)).

% ************* Adjudicataria **************************
% Adicionar conhecimento imperfeito incerto, referente a entidade adjudicataria.
novoAdjudicataria(Nome,Nif,Morada,incerto):- processa(Morada,R),evolucao(excecao(e_ada(Nome,Nif,R),incerto)).

% Adicionar conhecimento imperfeito impreciso, referente a entidade adjudicataria.
novoAdjudicataria(Nome,Nif,Morada,impreciso):- processa(Morada,R),evolucao(excecao(e_ada(Nome,Nif,R),impreciso)).

% Adicionar conhecimento imperfeito interdito, referente a entidade adjudicataria.
novoAdjudicataria(Nome,Nif,Morada,interdito):- evolucao(excecao(e_ada(('I',Nome),('I',Nif),Morada),interdito)),processa(Morada,R),evolucao(excecao(e_ada(Nome,Nif,R),interdito)).


% ************* Contratos **************************

% Insere um contrato Incerto
novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,incerto):- processaContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,R),
  evolucao(excecao(R,incerto)).

% Insere um contrato Incerto.
novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,impreciso):- processaContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,R),
  evolucao(excecao(R,impreciso)).

% Insere um contrato Interdito.
novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,interdito):- evolucao(excecao(contrato(('I',Id),Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),interdito)),
  processaContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,R),
  evolucao(excecao(R,info_interdito)).

% Retorna o novo contrato alterado, de forma a ocultar a informação.
processaContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,contrato(Id,R2,R3,R4,R5,R6,R7,R8,R9,R10)):-
  (processa(Id,R1),processa(Nif_ad,R2),processa(Nif_ada,R3),processa(TipoC,R4),processa(TipoP,R5),processa(Descricao,R6),processa(Custo,R7),processa(Prazo,R8),processa(Local,R9),processa(Data,R10)).

% Processa um parâmetro, para conhecimento imperfeito.
processa(interdito(X),'-').
processa(incerto,'N/A').
processa(X,X).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Procedimentos de involução do conhecimento Imperfeito.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% ************* Adjudicante **************************
% Remove conhecimento imperfeito interdito, referente a entidade adjudicataria.
removeAdjudicante(Nif):- removeInterdito_ad(Nif),
  encontraAdjudicante2(Nif,[C]),
  involucao(C).
% Adicionar conhecimento imperfeito excepto interdito, referente a entidade adjudicataria.
removeAdjudicante(Nif):- encontraAdjudicante2(Nif,[C]),
  involucao(C).
% 
removeInterdito_ad(Nif):- findall(evolucao(excecao(e_ad(('I',Nome),('I',Nif),Morada),TX)),
  evolucao(excecao(e_ad(('I',Nome),('I',Nif),Morada),TX)),[S]),
  involucao(S).
% ************* Adjudicataria **************************

removeAdjudicataria(Nif):- removeInterdito_ada(Nif),
  encontraAdjudicataria2(Nif,[C]),
  involucao(C).

removeAdjudicataria(Nif):- encontraAdjudicataria2(Nif,[C]),
  involucao(C).


removeInterdito_ada(Nif):- findall(evolucao(excecao(e_ada(('I',Nome),('I',Nif),Morada),TX)),
  evolucao(excecao(e_ada(('I',Nome),('I',Nif),Morada),TX)),[S]),
  involucao(S).

% ************* Contratos **************************

removeContrato(Id):-removeInterdito(Id),
  encontraContrato2(Id,[C]),
  involucao(C).

removeContrato(Id):-encontraContrato2(Id,[C]),
  involucao(C). 



removeInterdito(Id):-findall(excecao(contrato(('I',Id),Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),
  excecao(contrato(('I',Id),Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),TX),[S]),
  involucao(S).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Procedimentos de substituição do conhecimento ImPerfeito.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%Só se substui por conhecimento perfeito

subsE_ad(Nome,Nif,Morada):- findall(excecao(e_ad(Nome,Nif,M),P),excecao(e_ad(Nome,Nif,M),P),S),
                            length(S,1),
                            involucao(excecao(e_ad(Nome,Nif,M),P)),
                            novoAdjudicante(Nome,Nif,Morada).

subsE_ada(Nome,Nif,Morada):- findall(excecao(e_ada(Nome,Nif,M),P),excecao(e_ada(Nome,Nif,M),P),S),
                            length(S,1),
                            involucao(excecao(e_ada(Nome,Nif,M),P)),
                            novoAdjudicataria(Nome,Nif,Morada).



subsContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data):- encontraContrato2(Id,[C]),
  involucao(C), 
  removeInterdito(Id),
  novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data).


subsContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,TX):- encontraContrato2(Id,[C]),
  involucao(C), 
  removeInterdito(Id),
  novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,TX).



subsContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data):- encontraContrato2(Id,[C]),
  involucao(C), 
  novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data).


subsContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,TX):- encontraContrato2(Id,[C]),
  involucao(C), 
  novoContrato(Id,Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data,TX).






%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Testes .
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Invariantes do ajuste direto Respeitado.
% evolucao(contrato(20,700000000,700000005,'Aquisicao de Servicos','Ajuste Direto','contrato de intermediação financeira',5000,365,'Lisboa',"01-04-2019")).
% -*-


% 
% evolucao(contrato(60,700000003,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',5000000,1096,'Lisboa',"06-01-2020")).


% Mostra o resultado do Invariante da regra dos 3 anos.
% somarContratos(700000003,300000003,[2018,2019,2020],Tot).
% evolucao(contrato(61,700000003,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',69999,1096,'Lisboa',"07-01-2020")).
% evolucao(contrato(62,700000003,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',1,1096,'Lisboa',"07-01-2020")).
% evolucao(contrato(63,700000003,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',1,1096,'Lisboa',"07-01-2020")). 
% -*-




% Teste para provar como substitui o conhecimento imPerfeito para perfeito no caso dos Adjudicantes.
% novoAdjudicante('Costa',123).
% encontraAdjudicante(123,C).
% subsE_ad('Costa',123,'R da cruz B1 N90, Porto').
% encontraAdjudicante(123,C).
% e_ad('Costa',123,'N/A').
% -*-




% mostra que só insere contratos com entidade na Base de conhecimento.
% evolucao(contrato(63,1,300000003,'Aquisicao de Servicos','Concurso Publico','Controlo do trafego aerio ',1,1096,'Lisboa',"07-01-2020")).



%novoContrato(3,700000001,300000006,'Aquisicao de Servicos',interdito('Concurso Publico'),'Controlo das portagens ',100000,365,'Lisboa',"06-01-2010",interdito).
%novoContrato(3,700000001,300000006,'Aquisicao de Servicos',impreciso('Concurso Publico','Consulta Previa'),'Controlo das portagens ',incerto,365,'Lisboa',"06-01-2010",impreciso).

% findall((('I',Id),Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),excecao(contrato(('I',3),Nif_ad,Nif_ada,TipoC,TipoP,Descricao,Custo,Prazo,Local,Data),_),S).












