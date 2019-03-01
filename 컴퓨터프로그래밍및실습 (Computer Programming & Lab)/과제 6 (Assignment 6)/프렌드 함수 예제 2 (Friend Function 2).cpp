#include <iostream>
using namespace std;

class Date
{
	friend bool equals(Date d1, Date d2); // 프렌드 함수 선언
private:
	int year, month, day; // 년,월, 일
public:
	Date(int y, int m, int d);
};
Date::Date(int y, int m, int d)
{
	year = y;
	month = m;
	day = d;
}

bool equals(Date d1, Date d2)
{
	return d1.year == d2.year&&d1.month == d2.month&&d1.day == d2.day; // 두 날짜가 같으면 1 아니면 0 반환
}

int main()
{
	Date d1(1975, 5, 22), d2(2002, 8, 12);

	if (equals(d1, d2) == 1)
		cout << "두 날짜는 같다!" << endl;
	else
		cout << "두 날짜는 다르다!" << endl;
}
