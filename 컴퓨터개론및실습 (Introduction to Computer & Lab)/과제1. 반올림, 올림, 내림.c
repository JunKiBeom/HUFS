#include <stdio.h>
#pragma warning (disable:4996)

int main()
{
	double x;
	double y=0;
	double temp=0;
	printf("���ڸ� �Է��ϼ���. ");
	scanf("%lf", &x);

	printf("x		=	%.6lf\n", x);

	printf("x(�ݿø�)	=	%.3lf\n", x);

	temp = x;
	temp = (temp * 1000) - 0.5;
	printf("x(����)		=	%.3lf\n", temp/1000);

	y = x;
	y = (y * 1000) + 0.5;
	printf("x(�ø�)		=	%.3lf\n\n", y/1000);

	printf("201703091 �����\n");

}