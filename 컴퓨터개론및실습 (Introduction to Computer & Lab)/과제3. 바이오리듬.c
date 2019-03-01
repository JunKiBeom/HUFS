#include <stdio.h>
#include <math.h>
#include <time.h>
#pragma warning (disable:4996)

int today_y, today_m, today_d; // ���� ��¥�� ���������� �ޱ� ���� ����

#define PI 3.1415926535897932384626433832795028841971 // ���̰�


int monthdate(int _year, int _month) // �� ���� �ϼ� �Լ�
{
	int monthData[] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }; // �迭�� �̿�

	if (yoon(_year) == 1 && _month == 2) // ���� 2���ϰ�� 29�Ϸ� �� ����
	{
		return 29;
	}
	else
	{
		return monthData[_month];
	}
}


int yoon(int _year) // �����Լ� �����̸�1 �ƴϸ�0�� �� �޴� �Լ�
{
	if (((_year % 4) == 0 && (_year % 100) != 0) ||
		(_year % 400) == 0)
	{
		return 1;
	}
	return 0;

}

int howManyDays(int _year, int _month, int _day)
{
	int days = 0; // ��ü �� ��

	for (int i = _year + 1; i < today_y; i++) // ���� �� ������ �� �� ���
	{
		if (yoon(i) == 1)
		{
			days = days + 366;
		}
		else
		{
			days = days + 365;
		}
	}

	for (int i = _month + 1; i <= 12; i++) // �� ���� ī����
	{
		days = days + monthdate(_year, i);
	}
	for (int i = 1; i <= (today_m - 1); i++)
	{
		days = days + monthdate(today_y, i);
	}

	days = days + today_d; // �� �� ī����
	days = days + (monthdate(_year, _month) - _day);

	return days;
}


int main(void) // �����Լ�
{
	int year, month, day;

	struct tm*t; // ���� �ð� get
	time_t timer;

	timer = time(NULL);
	t = localtime(&timer);

	today_y = t->tm_year + 1900, today_m = t->tm_mon + 1, today_d = t->tm_mday;

	printf("��������� �Է��ϼ���.");
	scanf("%d.%d.%d", &year, &month, &day);
	printf("������ %d�� %d�� %d�� �Դϴ�.\n", today_y, today_m, today_d);
	
	for (int i=-7; i<=14; i++)
	{
	int days= howManyDays(year, month, day);
	days += i;

	double physical = sin((2.0*PI*days) / 23.0) * 100;
	double sens = sin((2.0*PI*days) / 28.0) * 100;
	double intel = sin((2.0*PI*days) / 33.0) * 100;
	
		printf("%d. %d. %d\n", today_y, today_m, today_d+i);
		printf("��ü����: %.2f\n", physical);
		printf("��������: %.2f\n", sens);
		printf("��������: %.2f\n", intel);
		printf("\n");
	}
	return 0;
}
