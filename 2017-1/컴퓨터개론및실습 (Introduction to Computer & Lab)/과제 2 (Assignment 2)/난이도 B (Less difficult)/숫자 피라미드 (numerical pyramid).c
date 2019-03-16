#include <stdio.h>
#pragma warning (disable:4996)
int main(void)
{
	int N, M, i = 1, j, k = 1;

	printf("어떤 유형으로 출력할까요?");
	scanf("%d", &N);
A:
	printf("행의 수를 입력해주세요 : ");
	scanf("%d", &M);

	while (M > 20)
	{
		printf("M의 값은 20을 넘을 수 없습니다.\n");
		goto A; //A의 문장으로 대체가능
	}

	if ((N == 3) || (N == 4))
	{
		if ((M % 2 != 1) && M <= 20)
		{
			while (M <= 20)
			{
				printf("M의 값은 홀수이어야 합니다.\n");
				goto A; //A의 문장으로 대체가능
			}
		}
	}

	switch (N)
	{
	case 1:
		for (i; i <= M; i++) //출력받을 줄 수 만큼 실행
		{
			for (j = i; j <M; j++) //위에서부터 공백으로 피라미드 만들기
				printf("  ");
			for (j = 0; j < i; j++) //숫자 출력
				printf("%3d ", k + j); //칸 맞추며
			printf("\n");
			k += i;
		}
		printf("\n");
		break;

	case 2:
		for (i = M; i >= 1; i--) //출력받을 줄 수 만큼 실행 (반대로 출력)
		{
			for (j = i; j <M; j++) //위에서부터 공백으로 피라미드 만들기
				printf("  ");
			for (j = 0; j < i; j++) //숫자 출력
				printf("%3d ", k + j); //칸 맞추며
			printf(" \n");
			k += i;
		}
		printf("\n");
		break;

	case 3:
		for (i; i <= M / 2 + 1; i++) //출력받을 줄 수 만큼 실행
		{
			for (j = i; j <M / 2 + 1; j++) //위에서부터 공백으로 피라미드 만들기
				printf("  ");
			for (j = 0; j < i; j++) //숫자 출력
				printf("%3d ", k + j); //칸 맞추며
			printf("\n");
			k += i;
		}

		for (i = M / 2; i >= 1; i--) //출력받을 줄 수 만큼 실행 (반대로 출력)
		{
			for (j = i; j <M / 2; j++) //위에서부터 공백으로 피라미드 만들기
				printf("  ");
			printf("  ");
			for (j = 0; j < i; j++) //숫자 출력
				printf("%3d ", k + j); //칸 맞추며
			printf(" \n");
			k += i;
		}
		printf("\n");
		break;

	case 4:
		for (i = M / 2 + 1; i > 1; i--) //출력받을 줄 수 만큼 실행 (반대로 출력)
		{
			for (j = i; j <M / 2 + 1; j++) //위에서부터 공백으로 피라미드 만들기
				printf("  ");

			for (j = 0; j < i; j++) //숫자 출력
				printf("%3d ", k + j); //칸 맞추며
			printf(" \n");
			k += i;
		}
		for (i; i <= M / 2 + 1; i++) //출력받을 줄 수 만큼 실행
		{
			for (j = i; j < M / 2 + 1; j++) //위에서부터 공백으로 피라미드 만들기
				printf("  ");
			for (j = 0; j < i; j++) //숫자 출력
				printf("%3d ", k + j); //칸 맞추며
			printf("\n");
			k += i;
		}
		printf("\n");
		break;
	}
	return 0;
}
