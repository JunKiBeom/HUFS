#include <iostream>
using namespace std;

class Company // ȸ�� Ŭ����
{
private:
	int sales, profit;
	friend void sub(Company& c); // ������ ����
public:
	Company();
};
Company::Company()
{
	sales = 0;
	profit = 0;
}
void sub(Company& c)
{
	cout << "profit = " << c.profit << endl; // sub�Լ��� Company�� private�κп� ���� ����
}

int main()
{
	Company c1;
	sub(c1); // profit = 0
}