#include <stdio.h>
#pragma warning (disable:4996)

int main()
{
	double x;
	double y=0;
	double temp=0;
	printf("숫자를 입력하세요. ");
	scanf("%lf", &x);

	printf("x		=	%.6lf\n", x);

	printf("x(반올림)	=	%.3lf\n", x);

	temp = x;
	temp = (temp * 1000) - 0.5;
	printf("x(내림)		=	%.3lf\n", temp/1000);

	y = x;
	y = (y * 1000) + 0.5;
	printf("x(올림)		=	%.3lf\n\n", y/1000);

	printf("201703091 전기범\n");

}