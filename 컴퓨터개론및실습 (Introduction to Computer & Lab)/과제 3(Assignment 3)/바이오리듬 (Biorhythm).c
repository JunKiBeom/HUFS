#include <stdio.h>
#include <math.h>
#include <time.h>
#pragma warning (disable:4996)

int today_y, today_m, today_d; // 오늘 날짜를 전역변수로 받기 위해 설정

#define PI 3.1415926535897932384626433832795028841971 // 파이값


int monthdate(int _year, int _month) // 각 달의 일수 함수
{
	int monthData[] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }; // 배열을 이용

	if (yoon(_year) == 1 && _month == 2) // 윤년 2월일경우 29일로 값 받음
	{
		return 29;
	}
	else
	{
		return monthData[_month];
	}
}


int yoon(int _year) // 윤년함수 윤년이면1 아니면0의 값 받는 함수
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
	int days = 0; // 전체 일 수

	for (int i = _year + 1; i < today_y; i++) // 올해 전 까지의 일 수 계산
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

	for (int i = _month + 1; i <= 12; i++) // 달 별로 카운팅
	{
		days = days + monthdate(_year, i);
	}
	for (int i = 1; i <= (today_m - 1); i++)
	{
		days = days + monthdate(today_y, i);
	}

	days = days + today_d; // 일 별 카운팅
	days = days + (monthdate(_year, _month) - _day);

	return days;
}


int main(void) // 메인함수
{
	int year, month, day;

	struct tm*t; // 오늘 시간 get
	time_t timer;

	timer = time(NULL);
	t = localtime(&timer);

	today_y = t->tm_year + 1900, today_m = t->tm_mon + 1, today_d = t->tm_mday;

	printf("생년월일을 입력하세요.");
	scanf("%d.%d.%d", &year, &month, &day);
	printf("오늘은 %d년 %d월 %d일 입니다.\n", today_y, today_m, today_d);
	
	for (int i=-7; i<=14; i++)
	{
	int days= howManyDays(year, month, day);
	days += i;

	double physical = sin((2.0*PI*days) / 23.0) * 100;
	double sens = sin((2.0*PI*days) / 28.0) * 100;
	double intel = sin((2.0*PI*days) / 33.0) * 100;
	
		printf("%d. %d. %d\n", today_y, today_m, today_d+i);
		printf("신체지수: %.2f\n", physical);
		printf("감정지수: %.2f\n", sens);
		printf("지성지수: %.2f\n", intel);
		printf("\n");
	}
	return 0;
}
