#include <iostream>
using namespace std;

class Date
{
	friend bool equals(Date d1, Date d2); // ������ �Լ� ����
private:
	int year, month, day; // ��,��, ��
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
	return d1.year == d2.year&&d1.month == d2.month&&d1.day == d2.day; // �� ��¥�� ������ 1 �ƴϸ� 0 ��ȯ
}

int main()
{
	Date d1(1975, 5, 22), d2(2002, 8, 12);

	if (equals(d1, d2) == 1)
		cout << "�� ��¥�� ����!" << endl;
	else
		cout << "�� ��¥�� �ٸ���!" << endl;
}