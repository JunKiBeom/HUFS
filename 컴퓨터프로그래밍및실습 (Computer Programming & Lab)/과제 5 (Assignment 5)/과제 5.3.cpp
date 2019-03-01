#include <iostream>
#include <string>
using namespace std;

/* set~ : ~������ get~ : ~������*/

class Account // ���� Ŭ����
{
protected:
	string account_number; // ���¹�ȣ
	int balance; // �ܾ�
public:
	Account(string A = "620-111222-333", int b = 1000000) :account_number(A), balance(b){} // �⺻ ������
	void setAccount_Number(string A);
	string getAccount_Number();
	void setBalance(int b);
	int getBalance();
	void deposit(int d); // �Ա� �Լ�
	void withdraw(int w); // ��� �Լ�
	void print();// ��� �Լ�
};
void Account::setAccount_Number(string A)
{
	account_number = A;
}
string Account::getAccount_Number()
{
	cout << "���¹�ȣ : " << account_number << endl;
	return account_number;
}
void Account::setBalance(int b)
{
	balance = b;
}
int Account::getBalance()
{
	cout << "�ܾ� : " << balance << endl;
	return balance;
}
void Account::deposit(int d)
{
	balance += d;
}
void Account::withdraw(int w)
{
	balance -= w;
}
void Account::print()
{
	getAccount_Number();
	getBalance();
}

class Interest :public Account // ���� Ŭ����, ���� Ŭ���� ���
{
private:
	double rate; // ������
	int rate_money; // ������*�ܾ�
public:
	Interest(string A = "620-111222-333", int b = 1000000, double r = 0) :Account(A, b), rate(r){} // �⺻ ������
	void setrate(double r);
	double getrate();
	void setcalc(); // ���� ��� �Լ�
	int getcalc();
	void print(); // ����Լ�
};
void Interest::setrate(double r)
{
	rate = r;
}
double Interest::getrate()
{
	cout << "������ : " << rate << endl;
	return rate;
}
void Interest::setcalc()
{
	rate_money = (rate*balance) / 100;
}
int Interest::getcalc()
{
	cout << "���� �ݾ� : " << rate_money << endl;
	return rate_money;
}
void Interest::print()
{
	Account::print();
	setcalc(); // ���� ��� �Լ� ȣ��, ��ȣ��� rate_money�� �ȵ�
	getrate();
	getcalc();
}

class Saving :public Account // ���� Ŭ����, ���� Ŭ���� ���
{
private:
	string saving_account_number; // ���� ���¹�ȣ
	int saving_balance = 0; // ���� �ܾ�
	int saving; // ���� �ݾ�
public:
	Saving(string san = "620-111222-333", int s = 0, string A = "620-111222-333", int b = 1000000) :saving_account_number(san), saving_balance(s), Account(A, b){} // �⺻ ������, ���ι� �ʱ�ȭ�����Ͽ� ���� ���¹�ȣ, ���� �ݾ� �� �ʱ�ȭ
	void setSaving_Account_Number(string SAN);
	string getSaving_Account_Number();
	void setSaving_Balance(int S); // ���� �Լ�
	int getSaving_Balance();
	void print(); // ����Լ�
};
void Saving::setSaving_Account_Number(string SAN)
{
	saving_account_number = SAN;
}
string Saving::getSaving_Account_Number()
{
	cout << "���� ���¹�ȣ : " << saving_account_number << endl;
	return saving_account_number;
}
void Saving::setSaving_Balance(int S)
{
	saving = S; // ���� �ݾ�
	balance -= S; // �ܾ� -= ���� �ݾ�
	saving_balance += S; // ���� �ܾ� += ���� �ݾ�
}
int Saving::getSaving_Balance()
{
	cout << "���� �ݾ� : " << saving << endl;
	cout << "���� �ܾ� : " << saving_balance << endl;
	return saving_balance;
}
void Saving::print()
{
	Account::print();
	cout << endl;
	getSaving_Account_Number();
	getSaving_Balance();
}

int main()
{
	Account A;
	Account B("620-123456-789", 1500000); // ���¹�ȣ, �ܾ�
	Interest C("620-123456-789", 1000000, 3); // ���¹�ȣ, �ܾ�, ������
	Saving D("620-987654-123", 0); // ���¹�ȣ, �ܾ�, ���� �ܾ�
	/* ������ */

	B.deposit(5000); // �Ա� �Լ� ȣ��
	B.withdraw(7000); // ��� �Լ� ȣ��

	D.setSaving_Balance(200000); // ���� �Լ� ȣ��, 20���� ����

	A.print();
	cout << "------------------------" << endl;
	B.print();
	cout << "------------------------" << endl;
	C.print();
	cout << "------------------------" << endl;
	D.print();
	cout << "------------------------" << endl;
	/* ����Լ� ȣ�� */

	D.setSaving_Balance(100000); // ���� �Լ� ȣ��, 10���� ����
	D.print();
	cout << "------------------------" << endl;
}