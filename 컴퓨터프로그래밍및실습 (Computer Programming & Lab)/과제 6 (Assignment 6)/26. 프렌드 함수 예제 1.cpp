#include <iostream>
using namespace std;

class Company // 회사 클래스
{
private:
	int sales, profit;
	friend void sub(Company& c); // 프렌드 선언
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
	cout << "profit = " << c.profit << endl; // sub함수는 Company의 private부분에 접근 가능
}

int main()
{
	Company c1;
	sub(c1); // profit = 0
}