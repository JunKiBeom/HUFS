#include<stdio.h>
#pragma warning (disable:4996)
int main()
{
	int i, yun = 0;
	int year, month;
	int day, day_1 = 0, day_2 = 0, yoon = 0;
	int month_day[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

	printf("��, ���� �Է��ϼ���:");
	scanf("%d %d", &year, &month);

	//���� ���ϱ�
	for (i = 1; i < year; i++)
	{
		if (i % 4 == 0 && ((i % 100 != 0) || (i % 400 == 0)))
		{
			yoon++;
			//printf("%d\n", i);
		}
	}
	//printf("����:%d��\n", special);


	/* 1)�Է³⵵ ���⵵���� �ϼ� */
	day_1 = 365 * (year - 1) + yoon;
	//printf("�ϼ�1:%d\n", day1);


	/* 2)�Է³⵵ 1�� 1�Ϻ��� �Է¿� 1�ϱ��� �ϼ� */
	for (i = 0; i < month - 1; i++)
	{
		day_2 += month_day[i];
	}
	day_2 += 1;
	//������ ��
	if ((year % 4 == 0 && !(year % 100 == 0)) || (year % 400 == 0))
	{
		yun = 1;
		if (month >= 3)
			day_2 += 1;
	}
	//������ �ƴ� ��
	else
	{
		yun = 0;
		day_2 = day_2;
	}
	//printf("�ϼ�2:%d\n", day2);


	/* 3) 1)�� 2)�� ���� ���ϼ� */
	day = day_1 + day_2;
	//printf("�� �ϼ�:%d\n", day);


	/* ���� ��� */
	printf("\n\t  %d��  %d��\n", year, month);
	printf("\t\t\t\t\t\n");
	printf(" SUN MON TUE WED THU FRI SAT\n");
	printf("\t\t\t\t\t\n");

	//���� ���Ͽ� ���� ����
	for (i = 0; i < day % 7; i++)
	{
		printf("    ");
	}

	int cnt = (day % 7);

	if (yun == 1 && month == 2)//���� 2���� ��
	{
		for (i = 1; i <= 29; i++)
		{
			cnt++;
			printf("%4d", i);
			if (cnt % 7 == 0)
				printf("\n");
		}
	}
	else//�� �� �Ϲ� ���
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


