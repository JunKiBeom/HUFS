#include <iostream>
#include <string>
using namespace std;

/* set~ : ~설정자 get~ : ~접근자*/

class Employee // 직원 클래스
{
protected:
	int id; // 사원번호
	string name; // 이름
	int pay; // 급여

public:
	Employee(int i = 0, string n = "미설정", int p = 0) :name(n), id(i), pay(p){} // 기본 생성자
	void setID(int i);
	int getID();
	void setname(string n);
	string getname();
	void setpay(int p);
	int getpay();
	void print(); // 출력함수
};
void Employee::setID(int i)
{
	id = i;
}
int Employee::getID()
{
	cout << "사원번호 : " << id << endl;
	return id;
}
void Employee::setname(string n)
{
	name = n;
}
string Employee::getname()
{
	cout << "이름 : " << name << endl;
	return name;
}
void Employee::setpay(int p)
{
	pay = p;
}
int Employee::getpay()
{
	cout << "급여 : " << pay << endl;
	return pay;
}

void Employee::print()
{
	getID();
	getname();
	getpay();
}

class Programmer : public Employee // 프로그래머 클래스, 직원 클래스 상속
{
private:
	string lang; // 언어
public:
	Programmer(int i = 0, string n = "미설정", int p = 0, string l = 0) :Employee(i, n, p), lang(l){} // 기본 생성자
	void setlang(string l);
	string getlang();
	void print(); // 출력함수
};
void Programmer::setlang(string l)
{
	lang = l;
}
string Programmer::getlang()
{
	cout << "주 사용 언어 : " << lang << endl;
	return lang;
}
void Programmer::print()
{
	Employee::print();
	getlang();
}

class Manager : public Employee // 매니저 클래스, 직원 클래스 상속
{
private:
	string part; // 부서
public:
	Manager(int i = 0, string n = "미설정", int p = 0, string pt = 0) :Employee(i, n, p), part(pt){} // 기본 생성자
	void setpart(string pt);
	string getpart();
	void print(); // 출력함수
};
void Manager::setpart(string pt)
{
	part = pt;
}
string Manager::getpart()
{
	cout << "부서 : " << part << endl;
	return part;
}
void Manager::print()
{
	Employee::print();
	getpart();
}


int main()
{
	Employee A;
	Employee B(12345, "김병호", 5000000); // 사원번호, 이름, 급여
	Programmer C(56789, "오순철", 4000000, "C언어"); // 사원번호, 이름, 급여, 언어
	Manager D(65432, "박금주", 4200000, "디자인팀"); // 사원번호, 이름, 급여, 부서
	/* 생성자 */

	A.print();
	cout << "------------------------" << endl;
	B.print();
	cout << "------------------------" << endl;
	C.print();
	cout << "------------------------" << endl;
	D.print();
	cout << "------------------------" << endl;
	/* 출력함수 호출 */
}
