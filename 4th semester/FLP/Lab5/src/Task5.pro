%	ВАРИАНТ:	2
%	ЗАДАНИЕ:	Удалить m элементов списка l, следующих после		
%			k-го элемента l. 
%			l - список, элементами которого являются списки.
domains
	i = integer
	li = integer*
	l = li*
predicates
	remove(i,i,l,l)
clauses
	remove(_,_,[],[]) :- !.
	remove(0,_,L,L) :- !.
	remove(M,0,[_|L],R) :-
		M1 = M - 1,
		remove(M1,0,L,R), !.
	remove(M,K,[H|L],[H|R]) :- 
		K1 = K - 1,
		remove(M,K1,L,R).

goal
	remove(2,1,[[1, 2], [3, 4] ,[5, 6], [7, 8]],R).

