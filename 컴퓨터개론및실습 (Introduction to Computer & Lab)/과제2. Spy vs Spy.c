#include <stdio.h>
#pragma warning (disable:4996)

int main()
{
	int X, Y;
	int longitude, latitude;
	int select;

	printf("(1) ��ȣȭ\t(2) ��ȣȭ : ");
	scanf("%d", &select);

	switch (select)
	{
	case 1:
		printf("X, Y�� ��ġ��? ");
		scanf("%d %d", &X, &Y);
		X *= 255, Y *= 255, X -= 8332, Y -= 26584;

		printf("��ȣȭ�� ��ġ�� %d\t%d�Դϴ�.\n", X += 543184, Y += 313787);
		break;

	case 2:
		printf("��ȣȭ�� ��ġ�� �Է��ϼ���. ");
		scanf("%d %d", &longitude, &latitude);
		longitude -= 543184, latitude -= 313787, longitude += 8332, latitude += 26584;
		printf("���� ��ġ�� ������ �����ϴ�. %d %d\n", longitude /= 255, latitude /= 255);
	}
	return 0;

}