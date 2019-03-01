#include <iostream>
#include <string>
using namespace std;

/* set~ : ~설정자 get~ : ~접근자*/

class Account // 계좌 클래스
{
protected:
	string account_number; // 계좌번호
	int balance; // 잔액
public:
	Account(string A = "620-111222-333", int b = 1000000) :account_number(A), balance(b){} // 기본 생성자
	void setAccount_Number(string A);
	string getAccount_Number();
	void setBalance(int b);
	int getBalance();
	void deposit(int d); // 입금 함수
	void withdraw(int w); // 출금 함수
	void print();// 출력 함수
};
void Account::setAccount_Number(string A)
{
	account_number = A;
}
string Account::getAccount_Number()
{
	cout << "계좌번호 : " << account_number << endl;
	return account_number;
}
void Account::setBalance(int b)
{
	balance = b;
}
int Account::getBalance()
{
	cout << "잔액 : " << balance << endl;
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

class Interest :public Account // 이자 클래스, 계좌 클래스 상속
{
private:
	double rate; // 이자율
	int rate_money; // 이자율*잔액
public:
	Interest(string A = "620-111222-333", int b = 1000000, double r = 0) :Account(A, b), rate(r){} // 기본 생성자
	void setrate(double r);
	double getrate();
	void setcalc(); // 이자 계산 함수
	int getcalc();
	void print(); // 출력함수
};
void Interest::setrate(double r)
{
	rate = r;
}
double Interest::getrate()
{
	cout << "이자율 : " << rate << endl;
	return rate;
}
void Interest::setcalc()
{
	rate_money = (rate*balance) / 100;
}
int Interest::getcalc()
{
	cout << "이자 금액 : " << rate_money << endl;
	return rate_money;
}
void Interest::print()
{
	Account::print();
	setcalc(); // 이자 계산 함수 호출, 미호출시 rate_money값 안들어감
	getrate();
	getcalc();
}

class Saving :public Account // 적금 클래스, 계좌 클래스 상속
{
private:
	string saving_account_number; // 적금 계좌번호
	int saving_balance = 0; // 적금 잔액
	int saving; // 적금 금액
public:
	Saving(string san = "620-111222-333", int s = 0, string A = "620-111222-333", int b = 1000000) :saving_account_number(san), saving_balance(s), Account(A, b){} // 기본 생성자, 메인문 초기화로인하여 적금 계좌번호, 적금 금액 선 초기화
	void setSaving_Account_Number(string SAN);
	string getSaving_Account_Number();
	void setSaving_Balance(int S); // 적금 함수
	int getSaving_Balance();
	void print(); // 출력함수
};
void Saving::setSaving_Account_Number(string SAN)
{
	saving_account_number = SAN;
}
string Saving::getSaving_Account_Number()
{
	cout << "적금 계좌번호 : " << saving_account_number << endl;
	return saving_account_number;
}
void Saving::setSaving_Balance(int S)
{
	saving = S; // 적금 금액
	balance -= S; // 잔액 -= 적금 금액
	saving_balance += S; // 적금 잔액 += 적금 금액
}
int Saving::getSaving_Balance()
{
	cout << "적금 금액 : " << saving << endl;
	cout << "적금 잔액 : " << saving_balance << endl;
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
	Account B("620-123456-789", 1500000); // 계좌번호, 잔액
	Interest C("620-123456-789", 1000000, 3); // 계좌번호, 잔액, 이자율
	Saving D("620-987654-123", 0); // 계좌번호, 잔액, 적금 잔액
	/* 생성자 */

	B.deposit(5000); // 입금 함수 호출
	B.withdraw(7000); // 출금 함수 호출

	D.setSaving_Balance(200000); // 적금 함수 호출, 20만원 적금

	A.print();
	cout << "------------------------" << endl;
	B.print();
	cout << "------------------------" << endl;
	C.print();
	cout << "------------------------" << endl;
	D.print();
	cout << "------------------------" << endl;
	/* 출력함수 호출 */

	D.setSaving_Balance(100000); // 적금 함수 호출, 10만원 적금
	D.print();
	cout << "------------------------" << endl;
}
