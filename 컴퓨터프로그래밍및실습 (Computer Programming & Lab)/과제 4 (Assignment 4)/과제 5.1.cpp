#include <iostream>
#include <string>
using namespace std;

/* set~ : ~������ get~ : ~������*/

class Employee // ���� Ŭ����
{
protected:
	int id; // �����ȣ
	string name; // �̸�
	int pay; // �޿�

public:
	Employee(int i = 0, string n = "�̼���", int p = 0) :name(n), id(i), pay(p){} // �⺻ ������
	void setID(int i);
	int getID();
	void setname(string n);
	string getname();
	void setpay(int p);
	int getpay();
	void print(); // ����Լ�
};
void Employee::setID(int i)
{
	id = i;
}
int Employee::getID()
{
	cout << "�����ȣ : " << id << endl;
	return id;
}
void Employee::setname(string n)
{
	name = n;
}
string Employee::getname()
{
	cout << "�̸� : " << name << endl;
	return name;
}
void Employee::setpay(int p)
{
	pay = p;
}
int Employee::getpay()
{
	cout << "�޿� : " << pay << endl;
	return pay;
}

void Employee::print()
{
	getID();
	getname();
	getpay();
}

class Programmer : public Employee // ���α׷��� Ŭ����, ���� Ŭ���� ���
{
private:
	string lang; // ���
public:
	Programmer(int i = 0, string n = "�̼���", int p = 0, string l = 0) :Employee(i, n, p), lang(l){} // �⺻ ������
	void setlang(string l);
	string getlang();
	void print(); // ����Լ�
};
void Programmer::setlang(string l)
{
	lang = l;
}
string Programmer::getlang()
{
	cout << "�� ��� ��� : " << lang << endl;
	return lang;
}
void Programmer::print()
{
	Employee::print();
	getlang();
}

class Manager : public Employee // �Ŵ��� Ŭ����, ���� Ŭ���� ���
{
private:
	string part; // �μ�
public:
	Manager(int i = 0, string n = "�̼���", int p = 0, string pt = 0) :Employee(i, n, p), part(pt){} // �⺻ ������
	void setpart(string pt);
	string getpart();
	void print(); // ����Լ�
};
void Manager::setpart(string pt)
{
	part = pt;
}
string Manager::getpart()
{
	cout << "�μ� : " << part << endl;
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
	Employee B(12345, "�躴ȣ", 5000000); // �����ȣ, �̸�, �޿�
	Programmer C(56789, "����ö", 4000000, "C���"); // �����ȣ, �̸�, �޿�, ���
	Manager D(65432, "�ڱ���", 4200000, "��������"); // �����ȣ, �̸�, �޿�, �μ�
	/* ������ */

	A.print();
	cout << "------------------------" << endl;
	B.print();
	cout << "------------------------" << endl;
	C.print();
	cout << "------------------------" << endl;
	D.print();
	cout << "------------------------" << endl;
	/* ����Լ� ȣ�� */
}