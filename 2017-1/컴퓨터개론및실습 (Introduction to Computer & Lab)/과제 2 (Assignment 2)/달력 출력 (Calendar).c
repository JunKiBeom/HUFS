#include<stdio.h>
#pragma warning (disable:4996)
int main()
{
	int i, yun = 0;
	int year, month;
	int day, day_1 = 0, day_2 = 0, yoon = 0;
	int month_day[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

	printf("년, 월을 입력하세요:");
	scanf("%d %d", &year, &month);

	//윤년 구하기
	for (i = 1; i < year; i++)
	{
		if (i % 4 == 0 && ((i % 100 != 0) || (i % 400 == 0)))
		{
			yoon++;
			//printf("%d\n", i);
		}
	}
	//printf("윤년:%d번\n", special);


	/* 1)입력년도 전년도까지 일수 */
	day_1 = 365 * (year - 1) + yoon;
	//printf("일수1:%d\n", day1);


	/* 2)입력년도 1월 1일부터 입력월 1일까지 일수 */
	for (i = 0; i < month - 1; i++)
	{
		day_2 += month_day[i];
	}
	day_2 += 1;
	//윤년일 때
	if ((year % 4 == 0 && !(year % 100 == 0)) || (year % 400 == 0))
	{
		yun = 1;
		if (month >= 3)
			day_2 += 1;
	}
	//윤년이 아닐 때
	else
	{
		yun = 0;
		day_2 = day_2;
	}
	//printf("일수2:%d\n", day2);


	/* 3) 1)과 2)를 더한 총일수 */
	day = day_1 + day_2;
	//printf("총 일수:%d\n", day);


	/* 제목 출력 */
	printf("\n\t  %d년  %d월\n", year, month);
	printf("\t\t\t\t\t\n");
	printf(" SUN MON TUE WED THU FRI SAT\n");
	printf("\t\t\t\t\t\n");

	//시작 요일에 맞춰 정렬
	for (i = 0; i < day % 7; i++)
	{
		printf("    ");
	}

	int cnt = (day % 7);

	if (yun == 1 && month == 2)//윤년 2월일 때
	{
		for (i = 1; i <= 29; i++)
		{
			cnt++;
			printf("%4d", i);
			if (cnt % 7 == 0)
				printf("\n");
		}
	}
	else//그 외 일반 출력
	{
		for (i = 1; i <= month_day[month - 1]; i++)
		{
			cnt++;
			printf("%4d", i);
			if (cnt % 7 == 0)
				printf("\n");
		}
	}
	printf("\n\n");
}


