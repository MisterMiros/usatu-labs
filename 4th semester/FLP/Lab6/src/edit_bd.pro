domains
	name = string
	action = string
database
	male(name)
	female(name)
	parent(name,name)
predicates
	nondeterm run()
	nondeterm start_add_facts(action)
	add_fact(action)
	add_fact_check(action)
clauses	
	start_add_facts("y") :- 
		add_fact("y").
	start_add_facts(_) :- !.
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
	add_fact_check("m") :- !,
		write("Введите имя: "),
		readln(A),
		assertz(male(A)).
	add_fact_check("f") :- !,
		write("Введите имя: "),
		readln(A),
		assertz(female(A)).
	add_fact_check("p") :- !,
		write("Введите имя родителя: "),
		readln(A),
		write("Введите имя ребёнка: "),
		readln(B),
		assertz(parent(A,B)).
	run() :- 
		write("Чтение БД... "),
		consult("base.bd"),
		write("Готово!"), nl,
		write("Начать ввод предикатов? (y,n)"),
		readln(A),
		start_add_facts(A),
		write("Сохраняем БД... "),
		save("base.bd"),
		write("Готово!"), nl.		
goal
	run().