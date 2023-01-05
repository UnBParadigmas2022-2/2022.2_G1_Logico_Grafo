% Declaracao de Predicados Dinamicos
:- dynamic grafo/1. % grafo
:- dynamic vertice/2. % vertices
:- dynamic aresta/3. % arestas com peso 1
:- dynamic aresta/4. % arestas com peso variado

% Cria grafo
novo_grafo(G) :- 
	grafo(G),  % caso grafo nao exista retorna falso, evitando o ! a baixo
	write('Grafo ja existe, por favor insira outro'),
	!. % caso chegue aqui, significa que grafo ja existe entao nao sera recriado

novo_grafo(G) :-
	assertz(grafo(G)), % cria grafo
	write('Grafo '), write(G), write(' foi criado'), % imprime mensagem avisando que grafo foi criado
	!.

% Deleta grafo criado
deleta_grafo(G) :-
	grafo(G), % valida se grafo existe
	retractall(aresta(G,_,_,_)), % remove todas as arestas do grafo
	retractall(vertice(G,_)), % remove todos os vertices do grafo
	retractall(grafo(G)), % remove o grafo
	write('Grafo '),write(G),write(' foi apagado com sucesso'),
	!.

% Remove vertice V ao grafo G
novo_vertice(G, V) :-
	nonvar(G),
	nonvar(V),
	grafo(G),
	vertice(G, V),
	write('O Vertice '), write(V), write(' nao foi adiciona ao grafo '), write(G), write(', pois ja existe'),
	!.

novo_vertice(G, V) :-
	assertz(vertice(G, V)), % insere novo vertice 
	write('O Vertice '), write(V), write(' foi adicionado ao grafo '), write(G),
	!.

% Remove vertice i

remove_vertice(G, V):-
	nonvar(G),
	nonvar(V),
	grafo(G),
	retractall(aresta(G,V,_,_)),
	retractall(aresta(G,_,V,_)),
	retractall(vertice(G,V)),
	write('Foram removidos todos os vertices eh arestas no grafo '), write(G), write(' relacionados ao vertice'), write(V), 
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
	write('Foi adicionado ao grafo '), write(G), write(' aresta: '), write(U),write('->'), write(V), write(' com peso igual a '),write(Weight), write('\n'),
	!.

% Remove arestas

remove_aresta(G, U, V):-
	nonvar(G),
	nonvar(U),
	nonvar(V),
	grafo(G),
	retractall(aresta(G,U,V,_)),
	write('Conexao unidirecional '),write(U),write('->'), write(V), write(' foi removido do grafo '), write(G),
	!.

remove_aresta_bi(G, U, V):-
	nonvar(G),
	nonvar(U),
	nonvar(V),
	grafo(G),
	retractall(aresta(G,U,V,_)),
	retractall(aresta(G,V,U,_)),
	write('Conexao bidirecional '),write(U),write('--'), write(V), write(' foi removido do grafo '), write(G),
	!.

% Verify If Es Is A List Containing All G's arestas
arestas(G, Es) :-
	nonvar(G),
	grafo(G),
	aresta = aresta(G, _, _, _),
	findall(aresta, aresta, arestas),
	Es = arestas.

% Verify If Ns Is A List Containing All vertice V's Neighbors
neighbors(G, V, Ns) :-
	nonvar(G),
	nonvar(V),
	grafo(G),
	vertice(G, V),
	Neighbor = aresta(G, V, _, _),
	findall(Neighbor, Neighbor, Neighbors),
	Ns = Neighbors.

% Output All Of G's arestas
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
