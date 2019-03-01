#include <iostream>
#include <string>
using namespace std;

/* set~ : ~������ get~ : ~������*/

class Worker // �ٷ��� Ŭ����
{
protected:
	string name; // �̸�
	int pay; // �ð��� �ӱ�
public:
	Worker(string n = "�̼���", int p = 10000) :name(n), pay(p){} // �⺻ ������
	void setName(string n);
	string getName();
	void setPay(int p);
	int getPay();
	void print(); // ��� �Լ�
};
void Worker::setName(string n)
{
	name = n;
}
string Worker::getName()
{
	cout << "�̸� : " << name << endl;
	return name;
}
void Worker::setPay(int p)
{
	pay = p;
}
int Worker::getPay()
{
	cout << "�ð��� �ӱ� : " << pay << endl;
	return pay;
}
void Worker::print()
{
	getName();
	getPay();
}

class PartTimer :public Worker // �ð� �ٷ��� Ŭ����, �ٷ��� Ŭ���� ���
{
protected:
	int work_time; // ���� �ð�
	int weekly_pay; // �ֱ�
public:
	PartTimer(string n = "�̼���", int p = 10000, int wt = 0) :Worker(n, p), work_time(wt), weekly_pay(0){} // �⺻ ������
	void setWork_Time(int wt);
	int getWork_Time();
	void setWeekly_Pay(); // �ֱ� ��� �Լ�
	int getWeekly_Pay();
	void print(); // ��� �Լ�
};
void PartTimer::setWork_Time(int wt)
{
	work_time = wt;
}
int PartTimer::getWork_Time()
{
	cout << "���� �ð� : " << work_time << endl;
	return work_time;
}
void PartTimer::setWeekly_Pay()
{
	if (work_time <= 40) // ���� �ð� 40�ð����� : �ֱ� = ���� �ð�*�ð��� �ӱ�
		weekly_pay = (work_time*pay);
	else if (work_time > 40) // ���� �ð� 40�ð� �ʰ� : �ֱ� = ((���ѽð� - 40)*(�ð��� �ӱ�*1.5)) + (40 * �ð��� �ӱ�)
		weekly_pay = ((work_time - 40)*(pay*1.5)) + (40 * pay);
}
int PartTimer::getWeekly_Pay()
{
	cout << "���� �ֱ� : " << weekly_pay << endl;
	return weekly_pay;
}
void PartTimer::print()
{
	Worker::print();
	getWork_Time();
	setWeekly_Pay(); // �ֱ� ��� �Լ� ȣ��, �� ȣ��� weekly_pay�� �ȵ�
	getWeekly_Pay();
}

class Monthly_Paid :public Worker // ���� �ٷ��� Ŭ����, �ٷ��� Ŭ���� ���
{
protected:
	int work_time; // ���� �ð�
	int work_month; // ���� ���� ��
	int monthly_pay; // ����
public:
	Monthly_Paid(string n = "�̼���", int p = 10000, int wt = 0, int wm = 0) :Worker(n, p), work_time(wt), work_month(wm), monthly_pay(0){} // �⺻ ������
	void setWork_Time(int wt);
	int getWork_Time();
	void setWork_Month(int wm);
	int getWork_Month();
	void setMonthly_Pay(); // ���� ��� �Լ�
	int getMonthly_Pay();
	void print();
};
void Monthly_Paid::setWork_Time(int wt)
{
	work_time = wt;
}
int Monthly_Paid::getWork_Time()
{
	cout << "���� �ð� : " << work_time << endl;
	return work_time;
}
void Monthly_Paid::setWork_Month(int wm)
{
	work_month = wm;
}
int Monthly_Paid::getWork_Month()
{
	cout << "���� ���� �� : " << work_month << endl;
	return work_month;
}
void Monthly_Paid::setMonthly_Pay()
{
	monthly_pay = (work_time * pay)*(work_month * 30); // ���� = (���� �ð� * �ð��� �ӱ�)*(���� ���� �� * 30��(1��))
}
int Monthly_Paid::getMonthly_Pay()
{
	cout << "���� ���� : " << monthly_pay << endl;
	return monthly_pay;
}
void Monthly_Paid::print()
{
	Worker::print();
	getWork_Time();
	getWork_Month();
	setMonthly_Pay(); // ����0 ��� �Լ� ȣ��, �� ȣ��� monthly_pay�� �ȵ�
	getMonthly_Pay();
}

int main()
{
	Worker A;
	Worker B("�躴ȣ", 10000); // �̸�, �ð��� �ӱ�
	PartTimer C("����ö", 15000, 30); // �̸�, �ð��� �ӱ�, ���� �ð�
	PartTimer D("�谭ȣ", 15000, 44); // �̸�, �ð��� �ӱ�, ���� �ð�
	Monthly_Paid E("�ڱ���", 15000, 54, 3); // �̸�, �ð��� �ӱ�, ���� �ð�, ���� ���� ��
	/* ������ */

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
	/* ����Լ� ȣ�� */

}