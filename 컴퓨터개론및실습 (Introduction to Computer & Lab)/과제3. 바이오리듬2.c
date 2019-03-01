#include <stdio.h>
#include <math.h>
#include <time.h>
#pragma warning (disable:4996)

#define PI 3.1415926535897932384626433832795028841971 // ���̰�

int year, month, day; // ������� ����
int today_y, today_m, today_d; // ���� ��¥�� ���������� �ޱ� ���� ����


int birth(year) // �¾ ���� ��¥ ���
{
	int days, y_days;

	days = day-1;
	switch (month-1) // �¾ �� 1��1�� ~ �¾ �� ���� ��¥ ���
	{
	case 12: days += 31;
	case 11: days += 30;
	case 10: days += 31;
	case 9: days += 30;
	case 8: days += 31;
	case 7: days += 31;
	case 6: days += 30;
	case 5: days += 31;
	case 4: days += 30;
	case 3: days += 31;
	case 2: days += 28;
	case 1: days += 31;

		if ((year % 4 == 0) &&((year % 100 != 0) || (year % 400 == 0)))
			days += 1;
	}
	
		y_days = 365 - days;
	//printf("%d", y_days);
	return y_days; // �¾ ���� ��ƿ� �� ��
}

int last_date(year) // ((���� - 1) + (�¾ �� - 1)) ��¥ ���
{
	int all_day = 0;

	all_day = ((today_y-1) - (year+1) + 1) * 365;
	for (year; year <= today_y-1; year++)
	{
		if ((year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)))
			all_day += 1;
	}
	//printf("%d", all_day);
	return all_day; // ((���� - 1) + (�¾ �� - 1))�� ��ƿ� �� ��
}

int this_date() // ������ ��¥ ���
{
	int days;

	days = today_d-1;
	switch (today_m-1)
	{
	case 12: days += 31;
	case 11: days += 30;
	case 10: days += 31;
	case 9: days += 30;
	case 8: days += 31;
	case 7: days += 31;
	case 6: days += 30;
	case 5: days += 31;
	case 4: days += 30;
	case 3: days += 31;
	case 2: days += 28;
	case 1: days += 31;

		if ((today_y % 4 == 0) &&((today_y % 100 != 0) || (today_y % 400 == 0)))
			days += 1;
	}
	//printf("%d", days);
	return days; // ���ñ��� ��ƿ� �� ��

}

int main(void) // �����Լ�
{

	struct tm*t; // ���� �ð� get
	time_t timer;

	timer = time(NULL);
	t = localtime(&timer);

	today_y = t->tm_year + 1900, today_m = t->tm_mon + 1, today_d = t->tm_mday;

	printf("������ �Է��ϼ���. ");
	scanf("%d.%d.%d", &year, &month, &day);
	printf("������ %d�� %d�� %d�� �Դϴ�.\n", today_y, today_m, today_d);

	for (int i = -7; i <= 7; i++) // ���� ��¥ 7�� ���� ���
	{
		int days = last_date(year) + birth(year) + this_date(year);
		days += i;

		double physical = sin((2.0*PI*days) / 23.0) * 100;
		double sens = sin((2.0*PI*days) / 28.0) * 100;
		double intel = sin((2.0*PI*days) / 33.0) * 100;

		printf("%d. %d. %d\n", today_y, today_m, today_d + i);
		printf("��ü����: %.2f\n", physical);
		printf("��������: %.2f\n", sens);
		printf("��������: %.2f\n", intel);
		//printf("%d\n",days);
	}
	return 0;
}