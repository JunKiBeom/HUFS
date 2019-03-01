#include <iostream>
#include <string>
using namespace std;

/* set~ : ~������ get~ : ~������*/

class Person // ��� Ŭ����
{
protected:
	string name; // �̸�
	int birth; // �������

public:
	Person(string n = "�̼���", int i = 20170000) :name(n), birth(i){} // �⺻ ������
	void setname(string n);
	string getname(); 
	void setBirth(int b);
	int getBirth();
	void print(); // ����Լ�
};
void Person::setname(string n)
{
	name = n;
}
string Person::getname()
{
	cout << "�̸� : " << name << endl;
	return name;
}
void Person::setBirth(int b)
{
	birth = b;
}
int Person::getBirth()
{
	cout << "������� : " << birth << endl;
	return birth;
}
void Person::print()
{
	getname();
	getBirth();
}

class Instructor : public Person // ������ Ŭ����, ��� Ŭ���� ���
{
private:
	string subject; // ���� ����
public:
	Instructor(string n = "�̼���", int i = 0, string s = 0) :Person(n, i), subject(s){} // �⺻ ������
	void setsubject(string s);
	string getsubject();
	void print(); // ����Լ�
};
void Instructor::setsubject(string s)
{
	subject = s;
}
string Instructor::getsubject()
{
	cout << "���� ���� : " << subject << endl;
	return subject;
}
void Instructor::print()
{
	Person::print();
	getsubject();
}

class Student : public Person // �л� Ŭ����, ��� Ŭ���� ���
{
private:
	string major; // ����
public:
	Student(string n = "�̼���", int i = 0, string m = "") :Person(n, i), major(m){} // �⺻ ������
	void setmajor(string pt);
	string getmajor();
	void print(); // ����Լ�
};
void Student::setmajor(string m)
{
	major = m;
}
string Student::getmajor()
{
	cout << "���� : " << major << endl;
	return major;
}
void Student::print()
{
	Person::print();
	getmajor();
}

int main()
{
	Person A;
	Person B("�躴ȣ", 19981114); // �̸�, �������
	Instructor C("����ö", 19851028, "C���"); // �̸�, �������, ���ǰ���
	Student D("�ڱ���", 19981110, "��ǻ�Ͱ���"); // �̸�, �������, ����
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