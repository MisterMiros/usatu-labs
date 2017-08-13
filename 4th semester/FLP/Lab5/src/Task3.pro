/****************************************************************************/
%	������ 3.
%	���� ���������. 
%	������� ������� /* � */, �������������� ����� ���������.
%	1.1.	����� ���� ����� �������������� � ���� ������,
%		�������������� � ������ ���������?
%	1.2.	��������� ������������  �����.
%	1.3.	� ������������ �������� � ���������������� ��������� 
%		������������ �����.
%	1.4.	����� ������ ��������� ���������?
%	1.5.	��������� � ����������� ����� ��������� � ��������� �
%		���������� ���������� � ������ � ���������� ������ 4.
     
domains
	l = integer*
predicates
	append2(l, l, l)
clauses
	append2([], L, L) :- !.
	append2([H|L1], L2, [H|L3]) :- append2(L1, L2, L3).
goal
	append2([1,2],[3],[1,2,3]).
	%append2([1],X,[1,2,3]).
	%append2(X,[3,4],[1,2,3,4]).
	%append2([1,2],[3,4],X).
	%append2(X,Y,[1,2,3,4]).
	%append2(X,[3,4],Y).
	%append2([1,2],X,Y).
	%append2(X,Y,Z).