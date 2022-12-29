% Dynamic Predicates Definitions
:- dynamic graph/1.
:- dynamic vertex/2.  
:- dynamic arc/3.     
:- dynamic arc/4. 

% Create_graph
new_graph(G) :-
	graph(G),
	!.

new_graph(G) :-
	assert(graph(G)),
	!.

% Delete_graph
delete_graph(G) :-
	graph(G),
	retractall(arc(G,_,_,_)),
	retractall(vertex(G,_)),
	retractall(graph(G)),
	!.

% Add Vertex V To Graph G
add_vertex(G, V) :-
	nonvar(G),
	nonvar(V),
	graph(G),
	vertex(G, V),
	!.

add_vertex(G, V) :- 
	assert(vertex(G, V)),
	!.

% Verify If Vs Is A List Containing All G's Vertices
vertices(G, Vs) :-
	nonvar(G),
	graph(G),
	findall(V, vertex(G, V), Ws),
	Vs = Ws.

% Output All Of G's Vertices
list_vertices(G) :-
	nonvar(G),
	graph(G),
	listing(vertex(G, _)).

% Add An Arc To The Graph G Between The Vertices U And V, With Weight
add_arc(G, U, V) :-  % add_arc/3, Add Arc With Weight 1
	add_arc(G, U, V, 1),
	!.

add_arc(G, U, V, Weight) :- 
	nonvar(G),
	nonvar(U),
	nonvar(V),
	nonvar(Weight),
	graph(G),
	arc(G, U, V, _),
	retractall(arc(G, U, V, _)),
	add_arc(G, U, V, Weight),
	!.


add_arc(G, U, V, Weight) :-  % Add arc(G, U, V, Weight) To The Database
	assert(arc(G, U, V, Weight)),
	!.

% Verify If Es Is A List Containing All G's Arcs
arcs(G, Es) :-
	nonvar(G),
	graph(G),
	Arc = arc(G, _, _, _),
	findall(Arc, Arc, Arcs),
	Es = Arcs.

% Verify If Ns Is A List Containing All Vertex V's Neighbors
neighbors(G, V, Ns) :-
	nonvar(G),
	nonvar(V),
	graph(G),
	vertex(G, V),
	Neighbor = arc(G, V, _, _),
	findall(Neighbor, Neighbor, Neighbors),
	Ns = Neighbors.

% Output All Of G's Arcs
list_arcs(G) :-
	nonvar(G),
	graph(G),
	listing(arc(G, _, _, _)).

% Output All Of G's Vertices And Arcs
list_graph(G) :-  % Calls list_vertices/1 And list_arcs/1
	nonvar(G),
	graph(G),
	list_vertices(G),
	list_arcs(G).