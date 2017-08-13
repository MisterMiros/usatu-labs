#include "stdafx.h"
#include <stdlib.h>
#include <iostream>
#include <string>
#include <locale>
#include <vector>
#include <windows.h>

#pragma comment(lib, "RGR.lib")

using std::cout;
using std::cin;

struct list {
	unsigned char eol;
	long value;
	struct list *next;
};

list* prepend_to_list(long, list*);
void destroy_list(list*);

typedef void(__stdcall *strategy_t)(list*, list*, long, long*);
typedef void(__stdcall *do_clash_t)(long, long, long, long*);

extern "C"
{
	void __stdcall strategy1(list*, list*, long, long*);
	void __stdcall strategy2(list*, list*, long, long*);
	void __stdcall do_clash(long, long, long, long*);
}

void vs_1(const int, std::vector<std::string>&);
void vs_2(const int, std::vector<std::string>&);
void vs_12(const int, std::vector<std::string>&);

int main()
{
	setlocale(LC_ALL, "Russian");
	cout << "Выберите размерность игры:\n";
	cout << "1 -- камень-ножницы-бумага\n";
	cout << "2 -- камень-ножницы-бумага-ящерица-Спок\n";
	cout << "3 -- произвольное число фигур\n";
	cout << "4 -- выход\n";
	int type;
	cin >> type;
	int C;
	std::vector<std::string> names;
	switch (type) {
	case 2:
		C = 5;
		names = std::vector<std::string>(C);
		names[0] = "Камень";
		names[1] = "Бумага";
		names[2] = "Ножницы";
		names[3] = "Cпок";
		names[4] = "Ящерица";
		break;
	case 3:
		do {
			cout << "Введите нечётное число фигур: ";
			cin >> C;
		} while (C % 2 == 0);
		names = std::vector<std::string>(C);
		for (int i = 0; i < C; i++) {
			names[i] = std::to_string(C);
		}
		break;
	case 4:
		return 0;
	case 1:
	default:
		C = 3;
		names = std::vector<std::string>(C);
		names[0] = "Камень";
		names[1] = "Бумага";
		names[2] = "Ножницы";
	}
	cout << "Выберите тип игры:\n";
	cout << "1 -- против оппонента 1\n";
	cout << "2 -- против оппонента 2\n";
	cout << "3 -- Оппонент 1 против оппонента 2\n";
	cout << "4 -- выход\n";
	int vs;
	cin >> vs;
	try {
		switch (vs) {
		case 1:
			vs_1(C, names);
			break;
		case 2:
			vs_2(C, names);
			break;
		case 3:
			vs_12(C, names);
			break;
		case 4:
			return 0;
		default:
			vs_12(C, names);
		}
	}
	catch (std::exception) {}
	system("pause");
	return 0;
}

list* prepend_to_list(long v, list* l) {
	list* res = new list;
	res->next = l;
	res->eol = 1;
	res->value = v;
	return res;
}

void destroy_list(list* l) {
	if (l->next == NULL) { delete l; return; }
	destroy_list(l->next);
	delete l;
}

void vs_player(const int C,
	std::vector<std::string>& names, strategy_t strategy) {
	cout << "Памятка по игре:\n";
	cout << "Номер\t--\tФигура\n";
	for (int i = 0; i < C; i++) {
		cout << i << "\t--\t" << names[i] << "\n";
	}
	list *p1 = new list, *p2 = new list;
	p1->eol = 2; p2->eol = 2;
	p1->next = NULL; p2->next = NULL;
	int wins = 0;
	long m1, m2, r;
	for (int i = 0; i < C; i++) {
		cout << "Раунд " << i << "\n";
		cout << "Ваш ход: ";
		cin >> m1;
		cout << "Вы выбрали: " << names[m1] << "\n";
		cout << "Ход оппонента: ";
		strategy(p2, p1, C, &m2);
		cout << names[m2] << "\n";
		p1 = prepend_to_list(m1, p1);
		p2 = prepend_to_list(m2, p2);
		do_clash(C, m1, m2, &r);
		wins += r;
		if (r == 0) {
			cout << "Ничья\n";
		}
		else if (r == 1) {
			cout << "Вы победили\n";
		}
		else if (r == -1) {
			cout << "Победил оппонент\n";
		}
	}
	if (wins > 0) {
		cout << "Вы победили. Число побед: " << wins << "\n";
	}
	else if (wins < 0) {
		cout << "Победил оппонент. Число побед: " << -wins << "\n";
	}
	else {
		cout << "Ничья\n";
	}
	destroy_list(p1);
	destroy_list(p2);
}

void vs_1(const int C, std::vector<std::string>& names) {
	vs_player(C, names, strategy1);
}

void vs_2(const int C, std::vector<std::string>& names) {
	vs_player(C, names, strategy2);
}

void vs_12(const int C, std::vector<std::string>& names) {
	list* p1 = new list;
	list* p2 = new list;
	p1->eol = 2; p2->eol = 2;
	p1->next = NULL; p2->next = NULL;
	int wins = 0;
	long m1, m2, r;
	for (int i = 0; i < C; i++) {
		strategy1(p1, p2, C, &m1);
		strategy2(p2, p1, C, &m2);
		p1 = prepend_to_list(m1, p1);
		p2 = prepend_to_list(m2, p2);

		do_clash(C, m1, m2, &r);
		wins += r;
		cout << "O1:" << names[m1] << " vs O2:" << names[m2] << " = " << r << "\n";
	}
	if (wins > 0) {
		cout << "Победил оппонент 1. Число побед: " << wins << "\n";
	}
	else if (wins < 0) {
		cout << "Победил оппонент 2. Число побед: " << -wins << "\n";
	}
	else {
		cout << "Ничья\n";
	}
	destroy_list(p1);
	destroy_list(p2);
}

