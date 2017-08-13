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
% правила родственных отношений
	% отец -- мужчина и родитель
	father(A,B) :-
		male(A),
		parent(A,B).
	% мать -- женщина и родитель
	mother(A,B) :-
		female(A),
		parent(A,B).
	% сын -- мужчина и ребёнок
	son(A,B) :-
		male(A),
		parent(B,A).
	% дочь -- женщина и ребёнок
	daughter(A,B) :-
		female(A),
		parent(B,A).
		
	not_equals(A,A) :- !, fail.
	not_equals(A,B) :- true.
	
	% брат -- мужчина, общий родитель, сам себе не брат
	brother(A,B) :-
		male(A),
		parent(X,A),
		parent(X,B),	
		not_equals(A,B).
	% братья -- A - мужчина, B - брат А.
	brothers(A,B) :-
		male(A),
		brother(B,A).
	
	% сестра -- женщина, общий родитель, сама себе не сестра
	sister(A,B) :-
		female(A),
		parent(X,A),
		parent(X,B),	
		not_equals(A,B).
	% сёстры -- A - женщина, B - сестра А.
	sisters(A,B) :-
		female(A),
		sister(B,A).
		
	% дедушка -- мужчина, родитель родителя
	grandfather(A,B) :-
		male(A),
		parent(X,B),
		parent(A,X).

	% бабушка -- женщина, родитель родителя
	grandmother(A,B) :-
		female(A),
		parent(X,B),
		parent(A,X).
		
	% дядя -- брат родителя
	uncle(A,B) :-
		parent(X,B),
		brother(A,X).

	% тётя -- сестра родителя
	aunt(A,B) :-
		parent(X,B),
		sister(A,X).
	% племянник -- ребёнок брата/сестры
	nephew(A,B) :-
		parent(X,A),
		parent(Y,B),
		parent(Y,X).

	% предок -- родитель, родители родителя
	ancestor(A,B) :- parent(A,B).
	ancestor(A,B) :-
		parent(X,B),
		ancestor(A,X).
	% потомок -- предок наоборот
	descendant(A,B) :-
		ancestor(B,A).
	% одно поколение -- 
	% есть общий ребёнок,
	% есть общий родитель,
	% на одном расстоянии от предков одного поколения	
	sameGen(A,B) :- parent(A,X), parent(B,X).
	sameGen(A,B) :- parent(X,A), parent(X,B).
	sameGen(A,B) :-
		parent(A1,A),
		parent(B1,B),
		sameGen(A1,B1).
% предикаты управления БД
	start_edit_bd("n") :- !.
	start_edit_bd("y") :-
		write("Управление базой данных"), nl,
		write("Что вы хотите сделать?"), nl,
		write("1 - вывести список фактов"), nl,
		write("2 - добавить факты"), nl,
		write("3 - удалить факты"), nl,
		write("4 - сохранить и выйти"), nl,
		readln(A),
		start_edit_bd(A).
	start_edit_bd("1") :-
		write("Мужчины:"), nl,
		findall(A,male(A), M),
		write(M), nl,
		write("Женщины:"), nl,
		findall(A, female(A), F),
		write(F), nl,
		write("Родители-дети:"), nl,
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
		write("Сохраняем БД... "),
		save("base.bd"),
		consult("base.bd"),
		write("Готово!"), nl, !.
	
	add_fact("e") :- !.
	add_fact(_) :- 
		write("Какой факт вы хотите добавить?"), nl,
		write("m - male"), nl,
		write("f - female"), nl,
		write("p - parent"), nl,
		write("e - exit"), nl,
		readln(A),
		add_fact_check(A),
		add_fact(A).
	add_fact_check("e") :- !.
	add_fact_check("m") :- 
		write("Введите имя: "),
		readln(A),
		assertz(male(A)).
	add_fact_check("f") :- 
		write("Введите имя: "),
		readln(A),
		assertz(female(A)).
	add_fact_check("p") :-
		write("Введите имя родителя: "),
		readln(A),
		write("Введите имя ребёнка: "),
		readln(B),
		assertz(parent(A,B)).
	remove_fact("e") :- !.
	remove_fact(_) :-
		write("Какой факт вы хотите удалить?"), nl,
		write("m - male"), nl,
		write("f - female"), nl,
		write("p - parent"), nl,
		write("e - exit"), nl,
		readln(A),
		remove_fact_check(A),
		remove_fact(A).
	remove_fact_check("e") :- !.
	remove_fact_check("m") :-
		write("Введите имя: "),
		readln(A),
		retractall(male(A)),
		retractall(parent(A,_)),
		retractall(parent(_,A)).
	remove_fact_check("f") :-
		write("Введите имя: "),
		readln(A),
		retractall(female(A)),
		retractall(parent(A,_)),
		retractall(parent(_,A)).		
	remove_fact_check("p") :-
		write("Введите имя родителя: "),
		readln(A),
		write("Введите имя ребёнка: "),
		readln(B),
		retractall(parent(A,B)).
% поиск
	find("9") :- !.
	find(_) :-
		write("Найти: "), nl,
		write("1 - родителей;"), nl,
		write("2 - братьев и сестёр;"), nl,
		write("3 - бабушек и дедушек;"), nl,
		write("4 - детей;"), nl,
		write("5 - племянников;"), nl,
		write("6 - предков;"), nl,
		write("7 - потомков;"), nl,
		write("8 - поколение;"), nl,
		write("9 - завершить работу"), nl,
		readln(A),
		find_relatives(A),
		find(A).
	find_relatives("9") :- !.
	find_relatives("1") :-
		write("Введите имя: "), readln(N),
		findall(X,mother(X,N),M),
		findall(X,father(X,N),F),
		write("Mать: "), write(M), nl,
		write("Отец: "), write(F), nl.
	find_relatives("2") :-
		write("Введите имя: "), readln(N),
		findall(X,brother(X,N),Bs),
		write("Братья: "), write(Bs), nl,
		findall(X,sister(X,N),Ss),
		write("Сёстры: "), write(Ss), nl.
	find_relatives("3") :-
		write("Введите имя: "), readln(N),
		findall(X,grandfather(X,N),Bs),
		write("Дедушки: "), write(Bs), nl,
		findall(X,grandmother(X,N),Ss),
		write("Бабушки: "), write(Ss), nl.
	find_relatives("4") :-
		write("Введите имя: "), readln(N),
		findall(X,parent(N,X),Bs),
		write("Дети: "), write(Bs), nl.
	find_relatives("5") :-
		write("Введите имя: "), readln(N),
		findall(X,nephew(X,N),Bs),
		write("Племянники/племянницы: "), write(Bs), nl.
	find_relatives("6") :-
		write("Введите имя: "), readln(N),
		findall(X,ancestor(X,N),Bs),
		write("Предки: "), write(Bs), nl.
	find_relatives("7") :-
		write("Введите имя: "), readln(N),
		findall(X,descendant(X,N),Bs),
		write("Потомки: "), write(Bs), nl.
	find_relatives("8") :-
		write("Введите имя: "), readln(N),
		findall(X,sameGen(X,N),Bs),
		write("Однопоколенники: "), write(Bs), nl.
		
	run() :- 
		write("Чтение БД... "),
		consult("base.bd"),
		write("Готово!"), nl,
		write("Начать ввод предикатов? (y,n)"),
		readln(A),
		start_edit_bd(A),	
		find("1").
		
goal
	run().
