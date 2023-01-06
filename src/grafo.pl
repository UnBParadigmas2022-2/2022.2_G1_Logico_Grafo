% Declaracao de Predicados Dinamicos
:- dynamic grafo/1. % grafo
:- dynamic vertice/2. % vertices
:- dynamic aresta/3. % arestas com peso 1
:- dynamic aresta/4. % arestas com peso variado

start :- initgraphprogram.

initgraphprogram :- write('Digite o nome desejado para a rede de conexoes:'), nl,
				read(Graph),
				novo_grafo(Graph),
				menu(Graph).

menu(Graph) :- repeat,
	nl,nl,nl,write('==MENU PRINCIPAL=='), nl,
	write('1 - Criar um usuario'),nl,
	write('2 - Criar um relacionamento'),nl,
	write('3 - Remover um usuario'),nl,
	write('4 - Remover um relacionamento'),nl,
	write('8 - Printar grafo'),nl,
	write('9 - Importar grupo 1 de Paradigmas de programacao'),nl,
	write('0 - sair do programa'),nl,
	read(X),
	escolha(X,Graph),
	X==0,
	!.

escolha(0,Graph) :- deleta_grafo(Graph),
					write('Adeus'),!.

escolha(1,Graph) :- write('Digite o nome do usuario a ser criado:'), nl,
				read(User),
				novo_vertice(Graph,User), !.

escolha(2,Graph) :- write('Digite a primeira pessoa que vai se relacionar'),nl,
					read(U1),
					write('Digite a segunda pessoaa que vai se relacionar'),nl,
					read(U2),
					nova_aresta_bi(Graph,U1,U2,amigos),!.

escolha(3,Graph) :- write('Digite o usuario que deseja remover'),nl,
					read(Rmuser),
					remove_vertice(Graph,Rmuser),!.

escolha(4,Graph) :- write('Digite o primeiro usuario relacionamento que deseja retirar:'),nl,
					read(U1),
					write('Digite o segundo usuario relacionamento que deseja retirar:'),nl,
					read(U2),
					remove_aresta_bi(Graph,U1,U2),!.

escolha(8, Graph) :- write('Resultado da consulta ao seu grafo:'), nl,
				lista_grafo(Graph),!.

escolha(9, Graph) :- novo_vertice(Graph,alvaro),
				novo_vertice(Graph,antonio),
				novo_vertice(Graph,davi),
				novo_vertice(Graph,francisco),
				novo_vertice(Graph,guilherme),
				novo_vertice(Graph,livinho),
				novo_vertice(Graph,mateus),
				novo_vertice(Graph,natanael),
				nl,
				nova_aresta_bi(Graph,alvaro,livinho,amigo),
				nova_aresta_bi(Graph,francisco,livinho,amigo),
				nova_aresta_bi(Graph,francisco,natanael,amigo),
				nova_aresta_bi(Graph,davi,natanael,amigo),
				nova_aresta_bi(Graph,davi,mateus,amigo),
				nova_aresta_bi(Graph,guilherme,livinho,amigo),
				nova_aresta_bi(Graph,antonio,guilherme,amigo),!.

escolha(_,_) :- write('numero ?'), nl, !.

% Cria grafo
novo_grafo(G) :- 
	grafo(G),  % caso grafo nao exista retorna falso, evitando o ! a baixo
	write('Grafo ja existe, por favor insira outro'),
	!. % caso chegue aqui, significa que grafo ja existe entao nao sera recriado

novo_grafo(G) :-
	assertz(grafo(G)), % cria grafo
	write('Grafo '), write(G), write(' foi criado'), nl, % imprime mensagem avisando que grafo foi criado
	!.

% Deleta grafo criado
deleta_grafo(G) :-
	grafo(G), % valida se grafo existe
	retractall(aresta(G,_,_,_)), % remove todas as arestas do grafo
	retractall(vertice(G,_)), % remove todos os vertices do grafo
	retractall(grafo(G)), % remove o grafo
	write('Grafo '),write(G),write(' foi apagado com sucesso'),nl,
	!.

% Remove vertice V ao grafo G
novo_vertice(G, V) :-
	nonvar(G),
	nonvar(V),
	grafo(G),
	vertice(G, V),
	write(V), write(' ja existe'),nl,
	!.

novo_vertice(G, V) :-
	assertz(vertice(G, V)), % insere novo vertice 
	write(V), write(' foi adicionado!'),nl,
	!.

% Remove vertice i

remove_vertice(G, V):-
	nonvar(G),
	nonvar(V),
	grafo(G),
	retractall(aresta(G,V,_,_)),
	retractall(aresta(G,_,V,_)),
	retractall(vertice(G,V)),
	write('O usuario '), write(V), write(' foi apagado com sucesso!'),nl, 
	!.

% Lista todos os vertices do grafo

% possiveis excessoes na listagem

lista_vertices(G) :-
	var(G),
	write('Erro! insira apenas o nome do grafo que quer verificar os vertices'),
	!.

lista_vertices(G) :-
	not(grafo(G)),
	write('Insira um grafo que exista no sistema'),
	!.

lista_vertices(G) :-
	grafo(G),
	write('Listando grafo '), write(G),
	listing(vertice(G, _)).

% Adiciona aresta ao grafo G, entre o vertice U e V, no sentido U -> V, caso nao seja informado peso sera = 1 
nova_aresta_bi(G,U,_,_):-
	not(vertice(G,U)),
	write('Usuario '), write(U), write(' invalido.') , nl, !.

nova_aresta_bi(G,_,V,_):-
	not(vertice(G,V)),
	write('Usuario '), write(V), write(' invalido.') , nl, !.

nova_aresta_bi(G,U,V,_):-
	aresta(G,U,V,_),
	write('Usuarios ja estao conectados!.'), nl, !.

nova_aresta_bi(G,U,V,Weight):-
	nonvar(G),
	nonvar(U),
	nonvar(V),
	nonvar(Weight),
	grafo(G),
	nova_aresta(G, U, V, Weight),
	nova_aresta(G, V, U, Weight),
	!.

nova_aresta(G, U, V) :-  % Adiciona aresta com peso 1 
	nonvar(G),
	nonvar(U),
	nonvar(V),
	nova_aresta(G, U, V, 1),
	!.

nova_aresta(G, U, V, Weight) :-
	nonvar(G),
	nonvar(U),
	nonvar(V),
	nonvar(Weight),
	grafo(G),
	aresta(G, U, V, _),
	retractall(aresta(G, U, V, _)),
	nova_aresta(G, U, V, Weight),
	!.

nova_aresta(G, U, V, Weight) :-  % Add aresta(G, U, V, Weight) To The Database
	assertz(aresta(G, U, V, Weight)),
	write(U),write(' se conectou com '), write(V), nl,
	!.

% Remove arestas

remove_aresta(G, U, V):-
	nonvar(G),
	nonvar(U),
	nonvar(V),
	grafo(G),
	retractall(aresta(G,U,V,_)),
	write('Conexao unidirecional entre '),write(U),write('e'), write(V), write(' foi removido!'), write(G),
	!.

remove_aresta_bi(G, U, V):-
	not(aresta(G,U,V,_)),
	write('A conexao entre '), write(U), write(" e "), write(V), write(' nao existe!'),nl,
	!.

remove_aresta_bi(G, U, V):-
	nonvar(G),
	nonvar(U),
	nonvar(V),
	grafo(G),
	retractall(aresta(G,U,V,_)),
	retractall(aresta(G,V,U,_)),
	write('Conexao bidirecional entre '),write(U),write(' e '), write(V), write(' foi removido!'),nl,
	!.

% Verify If Es Is A List Containing All Gs arestas
arestas(G, Es) :-
	nonvar(G),
	grafo(G),
	aresta = aresta(G, _, _, _),
	findall(aresta, aresta, arestas),
	Es = arestas,
	write(Es).

% Verify If Ns Is A List Containing All vertice Vs Neighbors
neighbors(G, V, Ns) :-
	nonvar(G),
	nonvar(V),
	grafo(G),
	vertice(G, V),
	Neighbor = aresta(G, V, _, _),
	findall(Neighbor, Neighbor, Neighbors),
	Ns = Neighbors.

% Output All Of Gs arestas
lista_arestas(G) :-
	nonvar(G),
	grafo(G),
	listing(aresta(G, _, _, _)).

% Lista conteudo do grafo
lista_grafo(G) :-  % Calls lista_vertices/1 And lista_arestas/1
	nonvar(G),
	grafo(G),
	lista_vertices(G),
	lista_arestas(G).
