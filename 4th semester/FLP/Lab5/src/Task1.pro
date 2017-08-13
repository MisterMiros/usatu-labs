/****************************************************************************/
%	 ������ 1.
%	���� ���������. 
%	1.1.	��������� ������������ ������� ���� p(a,Y,Z).
%	1.2.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.3.	������� ������� ������, ����� ��������� ������������ ������ 
%		������� ����������� ��������� p(X,Y,Z).
%	1.4.	��������� ������������ ������� ���� p(a,Y,Z).
%	1.5.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.6.	������� �� ������ ��������� ��� ��������� ���� ���������.
%	1.7.	�������� ���� p1(a,11). � ���� ������.
%	1.8.	��������� ������������ ������� ���� p(a,Y,Z).
%	1.9.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.10.	������� � ��������� ���������, ��������������� ���������� 
%		���������� 1.3.
%	1.11.	��������� ������������ ������� ���� p(a,Y,Z).
%	1.12.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.13.	��������� � ����������� ����� ��������� � ��������� �
%		���������� ���������� � ������ � ���������� ������ 2.
  
domains
	x 	= symbol
	y, z	= integer
predicates
	nondeterm p(x, y, z)
	nondeterm p1(x, y)
	p2(x, z)
	p3(x, y)
clauses
	p1(a, 1).
	p1(a,11).
	p2(a, 2).
	p3(a, 3).
	p(X, Y, Z) :- p1(X, Y), p2(X, Z).
	p(X, Y, Z) :- p2(X, Z), p3(X, Y).
goal
	p(a,X,Y).