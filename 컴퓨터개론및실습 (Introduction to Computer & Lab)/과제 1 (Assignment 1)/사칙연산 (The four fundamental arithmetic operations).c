#include <stdio.h>
#pragma warning (disable:4996)
int main()
{
	int a, b;
	printf("정수 두 개를 입력하세요 : ");
	scanf("%d %d", &a, &b);

	if (b <= 0)
	{
		printf("다시 입력하세요 : ");
		scanf("%d", &b);
	}

	else (b > 0);
	{
		printf("%d + %d = %d\n", a, b, a + b);
		printf("%d - %d = %d\n", a, b, a - b);
		printf("%d * %d = %d\n", a, b, a * b);
		printf("%d / %d = %d\n\n", a, b, a / b);


		printf("201703091 전기범\n");
		return 0;
	}
}
