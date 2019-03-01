#include <iostream>
#include <string>
using namespace std;

/* set~ : ~설정자 get~ : ~접근자*/

class Person // 사람 클래스
{
protected:
	string name; // 이름
	int birth; // 생년월일

public:
	Person(string n = "미설정", int i = 20170000) :name(n), birth(i){} // 기본 생성자
	void setname(string n);
	string getname(); 
	void setBirth(int b);
	int getBirth();
	void print(); // 출력함수
};
void Person::setname(string n)
{
	name = n;
}
string Person::getname()
{
	cout << "이름 : " << name << endl;
	return name;
}
void Person::setBirth(int b)
{
	birth = b;
}
int Person::getBirth()
{
	cout << "생년월일 : " << birth << endl;
	return birth;
}
void Person::print()
{
	getname();
	getBirth();
}

class Instructor : public Person // 강의자 클래스, 사람 클래스 상속
{
private:
	string subject; // 강의 과목
public:
	Instructor(string n = "미설정", int i = 0, string s = 0) :Person(n, i), subject(s){} // 기본 생성자
	void setsubject(string s);
	string getsubject();
	void print(); // 출력함수
};
void Instructor::setsubject(string s)
{
	subject = s;
}
string Instructor::getsubject()
{
	cout << "강의 과목 : " << subject << endl;
	return subject;
}
void Instructor::print()
{
	Person::print();
	getsubject();
}

class Student : public Person // 학생 클래스, 사람 클래스 상속
{
private:
	string major; // 전공
public:
	Student(string n = "미설정", int i = 0, string m = "") :Person(n, i), major(m){} // 기본 생성자
	void setmajor(string pt);
	string getmajor();
	void print(); // 출력함수
};
void Student::setmajor(string m)
{
	major = m;
}
string Student::getmajor()
{
	cout << "전공 : " << major << endl;
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
	Person B("김병호", 19981114); // 이름, 생년월일
	Instructor C("오순철", 19851028, "C언어"); // 이름, 생년월일, 강의과목
	Student D("박금주", 19981110, "컴퓨터공학"); // 이름, 생년월일, 전공
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