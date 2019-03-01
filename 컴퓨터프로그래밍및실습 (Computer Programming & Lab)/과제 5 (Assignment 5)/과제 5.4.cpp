#include <iostream>
#include <string>
using namespace std;

/* set~ : ~설정자 get~ : ~접근자*/

class Worker // 근로자 클래스
{
protected:
	string name; // 이름
	int pay; // 시간당 임금
public:
	Worker(string n = "미설정", int p = 10000) :name(n), pay(p){} // 기본 생성자
	void setName(string n);
	string getName();
	void setPay(int p);
	int getPay();
	void print(); // 출력 함수
};
void Worker::setName(string n)
{
	name = n;
}
string Worker::getName()
{
	cout << "이름 : " << name << endl;
	return name;
}
void Worker::setPay(int p)
{
	pay = p;
}
int Worker::getPay()
{
	cout << "시간당 임금 : " << pay << endl;
	return pay;
}
void Worker::print()
{
	getName();
	getPay();
}

class PartTimer :public Worker // 시간 근로자 클래스, 근로자 클래스 상속
{
protected:
	int work_time; // 일한 시간
	int weekly_pay; // 주급
public:
	PartTimer(string n = "미설정", int p = 10000, int wt = 0) :Worker(n, p), work_time(wt), weekly_pay(0){} // 기본 생성자
	void setWork_Time(int wt);
	int getWork_Time();
	void setWeekly_Pay(); // 주급 계산 함수
	int getWeekly_Pay();
	void print(); // 출력 함수
};
void PartTimer::setWork_Time(int wt)
{
	work_time = wt;
}
int PartTimer::getWork_Time()
{
	cout << "일한 시간 : " << work_time << endl;
	return work_time;
}
void PartTimer::setWeekly_Pay()
{
	if (work_time <= 40) // 일한 시간 40시간이하 : 주급 = 일한 시간*시간당 임금
		weekly_pay = (work_time*pay);
	else if (work_time > 40) // 일한 시간 40시간 초과 : 주급 = ((일한시간 - 40)*(시간당 임금*1.5)) + (40 * 시간당 임금)
		weekly_pay = ((work_time - 40)*(pay*1.5)) + (40 * pay);
}
int PartTimer::getWeekly_Pay()
{
	cout << "계산된 주급 : " << weekly_pay << endl;
	return weekly_pay;
}
void PartTimer::print()
{
	Worker::print();
	getWork_Time();
	setWeekly_Pay(); // 주급 계산 함수 호출, 미 호출시 weekly_pay값 안들어감
	getWeekly_Pay();
}

class Monthly_Paid :public Worker // 월급 근로자 클래스, 근로자 클래스 상속
{
protected:
	int work_time; // 일한 시간
	int work_month; // 일한 개월 수
	int monthly_pay; // 월급
public:
	Monthly_Paid(string n = "미설정", int p = 10000, int wt = 0, int wm = 0) :Worker(n, p), work_time(wt), work_month(wm), monthly_pay(0){} // 기본 생성자
	void setWork_Time(int wt);
	int getWork_Time();
	void setWork_Month(int wm);
	int getWork_Month();
	void setMonthly_Pay(); // 월급 계산 함수
	int getMonthly_Pay();
	void print();
};
void Monthly_Paid::setWork_Time(int wt)
{
	work_time = wt;
}
int Monthly_Paid::getWork_Time()
{
	cout << "일한 시간 : " << work_time << endl;
	return work_time;
}
void Monthly_Paid::setWork_Month(int wm)
{
	work_month = wm;
}
int Monthly_Paid::getWork_Month()
{
	cout << "일한 개월 수 : " << work_month << endl;
	return work_month;
}
void Monthly_Paid::setMonthly_Pay()
{
	monthly_pay = (work_time * pay)*(work_month * 30); // 월급 = (일한 시간 * 시간당 임금)*(일한 개월 수 * 30일(1달))
}
int Monthly_Paid::getMonthly_Pay()
{
	cout << "계산된 월급 : " << monthly_pay << endl;
	return monthly_pay;
}
void Monthly_Paid::print()
{
	Worker::print();
	getWork_Time();
	getWork_Month();
	setMonthly_Pay(); // 월급0 계산 함수 호출, 미 호출시 monthly_pay값 안들어감
	getMonthly_Pay();
}

int main()
{
	Worker A;
	Worker B("김병호", 10000); // 이름, 시간당 임금
	PartTimer C("오순철", 15000, 30); // 이름, 시간당 임금, 일한 시간
	PartTimer D("김강호", 15000, 44); // 이름, 시간당 임금, 일한 시간
	Monthly_Paid E("박금주", 15000, 54, 3); // 이름, 시간당 임금, 일한 시간, 일한 개월 수
	/* 생성자 */

	A.print();
	cout << "------------------------" << endl;
	B.print();
	cout << "------------------------" << endl;
	C.print();
	cout << "------------------------" << endl;
	D.print();
	cout << "------------------------" << endl;
	E.print();
	cout << "------------------------" << endl;
	/* 출력함수 호출 */

}