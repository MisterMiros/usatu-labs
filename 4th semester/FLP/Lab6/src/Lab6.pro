domains
	name = string
	action = string
	names = name*
database
	male(name)
	female(name)
	parent(name,name)
predicates
	nondeterm father(name,name)
	nondeterm mother(name,name)
	nondeterm son(name,name)
	nondeterm daughter(name,name)
	nondeterm brother(name,name)
	nondeterm sister(name,name)
	nondeterm brothers(name,name)
	nondeterm sisters(name,name)
	nondeterm grandfather(name,name)
	nondeterm grandmother(name,name)
	nondeterm uncle(name,name)
	nondeterm aunt(name,name)
	nondeterm nephew(name,name)
	nondeterm ancestor(name,name)
	nondeterm descendant(name,name)
	nondeterm sameGen(name,name)
	nondeterm run()
	nondeterm not_equals(name,name)
	nondeterm start_edit_bd(action)
	nondeterm add_fact(action)
	nondeterm add_fact_check(action)
	nondeterm remove_fact(action)
	nondeterm remove_fact_check(action)
	nondeterm find(action)
	nondeterm find_relatives(action)
clauses
% ������� ����������� ���������
	% ���� -- ������� � ��������
	father(A,B) :-
		male(A),
		parent(A,B).
	% ���� -- ������� � ��������
	mother(A,B) :-
		female(A),
		parent(A,B).
	% ��� -- ������� � ������
	son(A,B) :-
		male(A),
		parent(B,A).
	% ���� -- ������� � ������
	daughter(A,B) :-
		female(A),
		parent(B,A).
		
	not_equals(A,A) :- !, fail.
	not_equals(A,B) :- true.
	
	% ���� -- �������, ����� ��������, ��� ���� �� ����
	brother(A,B) :-
		male(A),
		parent(X,A),
		parent(X,B),	
		not_equals(A,B).
	% ������ -- A - �������, B - ���� �.
	brothers(A,B) :-
		male(A),
		brother(B,A).
	
	% ������ -- �������, ����� ��������, ���� ���� �� ������
	sister(A,B) :-
		female(A),
		parent(X,A),
		parent(X,B),	
		not_equals(A,B).
	% ����� -- A - �������, B - ������ �.
	sisters(A,B) :-
		female(A),
		sister(B,A).
		
	% ������� -- �������, �������� ��������
	grandfather(A,B) :-
		male(A),
		parent(X,B),
		parent(A,X).

	% ������� -- �������, �������� ��������
	grandmother(A,B) :-
		female(A),
		parent(X,B),
		parent(A,X).
		
	% ���� -- ���� ��������
	uncle(A,B) :-
		parent(X,B),
		brother(A,X).

	% ��� -- ������ ��������
	aunt(A,B) :-
		parent(X,B),
		sister(A,X).
	% ��������� -- ������ �����/������
	nephew(A,B) :-
		parent(X,A),
		parent(Y,B),
		parent(Y,X).

	% ������ -- ��������, �������� ��������
	ancestor(A,B) :- parent(A,B).
	ancestor(A,B) :-
		parent(X,B),
		ancestor(A,X).
	% ������� -- ������ ��������
	descendant(A,B) :-
		ancestor(B,A).
	% ���� ��������� -- 
	% ���� ����� ������,
	% ���� ����� ��������,
	% �� ����� ���������� �� ������� ������ ���������	
	sameGen(A,B) :- parent(A,X), parent(B,X).
	sameGen(A,B) :- parent(X,A), parent(X,B).
	sameGen(A,B) :-
		parent(A1,A),
		parent(B1,B),
		sameGen(A1,B1).
% ��������� ���������� ��
	start_edit_bd("n") :- !.
	start_edit_bd("y") :-
		write("���������� ����� ������"), nl,
		write("��� �� ������ �������?"), nl,
		write("1 - ������� ������ ������"), nl,
		write("2 - �������� �����"), nl,
		write("3 - ������� �����"), nl,
		write("4 - ��������� � �����"), nl,
		readln(A),
		start_edit_bd(A).
	start_edit_bd("1") :-
		write("�������:"), nl,
		findall(A,male(A), M),
		write(M), nl,
		write("�������:"), nl,
		findall(A, female(A), F),
		write(F), nl,
		write("��������-����:"), nl,
		findall(A, parent(A,B), PA),
		findall(B, parent(A,B), PB),
		write(PA), nl,
		write(PB), nl,
		start_edit_bd("y").
	start_edit_bd("2") :-
		add_fact("y"),
		start_edit_bd("y").
	start_edit_bd("3") :-
		remove_fact("y"),
		start_edit_bd("y").
	start_edit_bd("4") :-
		write("��������� ��... "),
		save("base.bd"),
		consult("base.bd"),
		write("������!"), nl, !.
	
	add_fact("e") :- !.
	add_fact(_) :- 
		write("����� ���� �� ������ ��������?"), nl,
		write("m - male"), nl,
		write("f - female"), nl,
		write("p - parent"), nl,
		write("e - exit"), nl,
		readln(A),
		add_fact_check(A),
		add_fact(A).
	add_fact_check("e") :- !.
	add_fact_check("m") :- 
		write("������� ���: "),
		readln(A),
		assertz(male(A)).
	add_fact_check("f") :- 
		write("������� ���: "),
		readln(A),
		assertz(female(A)).
	add_fact_check("p") :-
		write("������� ��� ��������: "),
		readln(A),
		write("������� ��� ������: "),
		readln(B),
		assertz(parent(A,B)).
	remove_fact("e") :- !.
	remove_fact(_) :-
		write("����� ���� �� ������ �������?"), nl,
		write("m - male"), nl,
		write("f - female"), nl,
		write("p - parent"), nl,
		write("e - exit"), nl,
		readln(A),
		remove_fact_check(A),
		remove_fact(A).
	remove_fact_check("e") :- !.
	remove_fact_check("m") :-
		write("������� ���: "),
		readln(A),
		retractall(male(A)),
		retractall(parent(A,_)),
		retractall(parent(_,A)).
	remove_fact_check("f") :-
		write("������� ���: "),
		readln(A),
		retractall(female(A)),
		retractall(parent(A,_)),
		retractall(parent(_,A)).		
	remove_fact_check("p") :-
		write("������� ��� ��������: "),
		readln(A),
		write("������� ��� ������: "),
		readln(B),
		retractall(parent(A,B)).
% �����
	find("9") :- !.
	find(_) :-
		write("�����: "), nl,
		write("1 - ���������;"), nl,
		write("2 - ������� � �����;"), nl,
		write("3 - ������� � �������;"), nl,
		write("4 - �����;"), nl,
		write("5 - �����������;"), nl,
		write("6 - �������;"), nl,
		write("7 - ��������;"), nl,
		write("8 - ���������;"), nl,
		write("9 - ��������� ������"), nl,
		readln(A),
		find_relatives(A),
		find(A).
	find_relatives("9") :- !.
	find_relatives("1") :-
		write("������� ���: "), readln(N),
		findall(X,mother(X,N),M),
		findall(X,father(X,N),F),
		write("M���: "), write(M), nl,
		write("����: "), write(F), nl.
	find_relatives("2") :-
		write("������� ���: "), readln(N),
		findall(X,brother(X,N),Bs),
		write("������: "), write(Bs), nl,
		findall(X,sister(X,N),Ss),
		write("Ѹ����: "), write(Ss), nl.
	find_relatives("3") :-
		write("������� ���: "), readln(N),
		findall(X,grandfather(X,N),Bs),
		write("�������: "), write(Bs), nl,
		findall(X,grandmother(X,N),Ss),
		write("�������: "), write(Ss), nl.
	find_relatives("4") :-
		write("������� ���: "), readln(N),
		findall(X,parent(N,X),Bs),
		write("����: "), write(Bs), nl.
	find_relatives("5") :-
		write("������� ���: "), readln(N),
		findall(X,nephew(X,N),Bs),
		write("����������/����������: "), write(Bs), nl.
	find_relatives("6") :-
		write("������� ���: "), readln(N),
		findall(X,ancestor(X,N),Bs),
		write("������: "), write(Bs), nl.
	find_relatives("7") :-
		write("������� ���: "), readln(N),
		findall(X,descendant(X,N),Bs),
		write("�������: "), write(Bs), nl.
	find_relatives("8") :-
		write("������� ���: "), readln(N),
		findall(X,sameGen(X,N),Bs),
		write("���������������: "), write(Bs), nl.
		
	run() :- 
		write("������ ��... "),
		consult("base.bd"),
		write("������!"), nl,
		write("������ ���� ����������? (y,n)"),
		readln(A),
		start_edit_bd(A),	
		find("1").
		
goal
	run().
