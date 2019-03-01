#include <stdio.h>
#include <math.h>
#include <time.h>
#pragma warning (disable:4996)

#define PI 3.1415926535897932384626433832795028841971 // 파이값

int year, month, day; // 생년월일 저장
int today_y, today_m, today_d; // 오늘 날짜를 전역변수로 받기 위해 설정


int birth(year) // 태어난 해의 날짜 계산
{
	int days, y_days;

	days = day-1;
	switch (month-1) // 태어난 해 1월1일 ~ 태어난 날 까지 날짜 계산
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
	return y_days; // 태어난 해의 살아온 날 수
}

int last_date(year) // ((올해 - 1) + (태어난 해 - 1)) 날짜 계산
{
	int all_day = 0;

	all_day = ((today_y-1) - (year+1) + 1) * 365;
	for (year; year <= today_y-1; year++)
	{
		if ((year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)))
			all_day += 1;
	}
	//printf("%d", all_day);
	return all_day; // ((올해 - 1) + (태어난 해 - 1))의 살아온 날 수
}

int this_date() // 올해의 날짜 계산
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
	return days; // 오늘까지 살아온 날 수

}

int main(void) // 메인함수
{

	struct tm*t; // 오늘 시간 get
	time_t timer;

	timer = time(NULL);
	t = localtime(&timer);

	today_y = t->tm_year + 1900, today_m = t->tm_mon + 1, today_d = t->tm_mday;

	printf("생일을 입력하세요. ");
	scanf("%d.%d.%d", &year, &month, &day);
	printf("오늘은 %d년 %d월 %d일 입니다.\n", today_y, today_m, today_d);

	for (int i = -7; i <= 7; i++) // 오늘 날짜 7일 전후 출력
	{
		int days = last_date(year) + birth(year) + this_date(year);
		days += i;

		double physical = sin((2.0*PI*days) / 23.0) * 100;
		double sens = sin((2.0*PI*days) / 28.0) * 100;
		double intel = sin((2.0*PI*days) / 33.0) * 100;

		printf("%d. %d. %d\n", today_y, today_m, today_d + i);
		printf("신체지수: %.2f\n", physical);
		printf("감정지수: %.2f\n", sens);
		printf("지성지수: %.2f\n", intel);
		//printf("%d\n",days);
	}
	return 0;
}