#include <stdio.h>
#pragma warning (disable:4996)
int main()
{
	int a, b;
	printf("���� �� ���� �Է��ϼ��� : ");
	scanf("%d %d", &a, &b);

	if (b <= 0)
	{
		printf("�ٽ� �Է��ϼ��� : ");
		scanf("%d", &b);
	}

	else (b > 0);
	{
		printf("%d + %d = %d\n", a, b, a + b);
		printf("%d - %d = %d\n", a, b, a - b);
		printf("%d * %d = %d\n", a, b, a * b);
		printf("%d / %d = %d\n\n", a, b, a / b);


		printf("201703091 �����\n");
		return 0;
	}
}