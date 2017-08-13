
include "rgr.inc"

global domains
	move = integer
	moves = move*
	count = integer
	result = integer
global predicates
	procedure strategy1(moves,moves,count,move) - (i,i,i,o) language stdcall
	procedure strategy2(moves,moves,count,move) - (i,i,i,o) language stdcall
	procedure do_clash(count,move,move,result) - (i,i,i,o) language stdcall
predicates
	nondeterm between(integer,integer,integer)
	clash(count,move,move,result)
	nondeterm custom_mod(integer,integer,integer)
	rand_move(count,move)
	strategy2_r(moves,moves,count,integer,move)
clauses		
	between(L, H, _):-
  		L >= H, !, fail.
	between(L, _, L).
	between(L, H, V):-
  		NL = L + 1, 
  		between(NL, H, V).
	custom_mod(A,B,C) :-
		A > 0,
		C = A mod B.
	custom_mod(A,B,C) :-
		A < 0,
		B1 = B * ((-A div B) + 1), 
		C = B1 + A.
	do_clash(C,A,B,X) :-
		clash(C,A,B,X).
	clash(C,A,A,0) :-
		between(0,C,A),!.
	clash(C,A,B,1) :-
		between(0,C,A),
		between(0,C,B),
		D = A - B,
		custom_mod(D,C,F),
		not(F mod 2 = 0),!.
	clash(C,A,B,-1) :-
		clash(C,B,A,1),!.
	rand_move(C,M) :-
    		random(C,M).
    	strategy1([],[],C,M) :-
    		rand_move(C,M), !.
	strategy1([_|_],[Ao|_],C,M) :-
		clash(C,M,Ao,1).

	strategy2([],[],C,M) :-
    		rand_move(C,M), !.
	strategy2(Am,Ao,C,M) :-
   		random(10,R),
    		strategy2_r(Am,Ao,C,R,M).
	strategy2_r([Am|_],[Ao|_],C,R,M) :-
    		R < 7,
    		clash(C,Am,Ao,1),
    		clash(C,M1,Am,1),
    		clash(C,M,M1,1),!.
	strategy2_r([Am|_],[Ao|_],C,R,M) :-
    		R < 7,
    		clash(C,Am,Ao,-1),
    		clash(C,M,Ao,1),!.
	strategy2_r(_,_,C,R,M) :-
    		R >= 7,
    		rand_move(C,M),!.
    	
GOAL
	true.