/****************************************************************************/
%	������ 2.	
%	���� ���������. 
%	������� ������� /* � */, �������������� ����� ���������.
%	1.1.	��������� ������������ ������� ���� r(X).
%	1.2.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.3.	��������� ������������ ������� ���� r(1).
%	1.4.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.5.	��������� ������������ ������� ���� r(2).
%	1.6.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.7.	������� ������� ������, ����� ��������� ������������ ������ 
%		������� ����������� ��������� r(X) ��� ��������.
%	1.8.	��������� ������������ ������� ���� r(X).
%	1.9.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.10.	��������� ������������ ������� ���� r(1).
%	1.11.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.12.	��������� ������������ ������� ���� r(2).
%	1.13.	� ������������ �������� � ���������������� ��������� 
%		������������ ����.
%	1.14.	��������� � ����������� ����� ��������� � ��������� �
%		���������� ���������� � ������ � ���������� ������ 3.

domains
	x = integer
predicates
	nondeterm r(x)
	r1(x)
	r2(x)
clauses
	r1(1).
	r2(2).
	r(X) :- r1(X), write("����������� ������ �����������"), nl.
	% r(X) :- r2(X), write("����������� ������ �����������"), nl.
goal
	r(2).

/* 1.1.	��������� ������������ ������� ���� r(X).
����������� ������ �����������
X=1
����������� ������ �����������
X=2
2 Solutions
������� r ����������� ��� X=1, X=2.
������ ���������� ����� write,
����� ����� �������� X, ��� ������� r(X)
��������� ������.
*/

/* 1.3.	��������� ������������ ������� ���� r(1).
����������� ������ �����������
yes
������ ���������� ����� write,
����� ����� �������� r(X).
*/

/* 1.5.	��������� ������������ ������� ���� r(2).
����������� ������ �����������
yes
������ ���������� ����� write,
����� ����� �������� r(X).
*/

/* 1.8.	��������� ������������ ������� ���� r(X).
����������� ������ �����������
X=1
1 Solution
�.� r(X) �����, ������ ��� X=1, ��
���������� ������ ������������
r(1).
*/

/* 1.10.	��������� ������������ ������� ���� r(1).
����������� ������ �����������
yes
�.�. ������� r(1) �����������, �� ����������
����� ��������� � ����������.
*/

/* 1.12.	��������� ������������ ������� ���� r(2).
no
�.�. ������� r(2) �� �����������,
�� ��������� no.
*/
