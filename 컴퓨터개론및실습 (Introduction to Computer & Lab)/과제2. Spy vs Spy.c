#include <stdio.h>
#pragma warning (disable:4996)

int main()
{
	int X, Y;
	int longitude, latitude;
	int select;

	printf("(1) 암호화\t(2) 복호화 : ");
	scanf("%d", &select);

	switch (select)
	{
	case 1:
		printf("X, Y의 위치는? ");
		scanf("%d %d", &X, &Y);
		X *= 255, Y *= 255, X -= 8332, Y -= 26584;

		printf("암호화된 위치는 %d\t%d입니다.\n", X += 543184, Y += 313787);
		break;

	case 2:
		printf("암호화된 위치를 입력하세요. ");
		scanf("%d %d", &longitude, &latitude);
		longitude -= 543184, latitude -= 313787, longitude += 8332, latitude += 26584;
		printf("현재 위치는 다음과 같습니다. %d %d\n", longitude /= 255, latitude /= 255);
	}
	return 0;

}