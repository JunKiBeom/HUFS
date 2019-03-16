#include <stdio.h>
#pragma warning (disable:4996)
int main()
{
	int x, N, M, temp, lay;
	printf("몇 단 부터 몇 단 까지을 표시할까요? ");
	scanf("%d %d", &N, &M);
	lay = M - N;
	temp = N;

	if (lay >= 1 && lay <= 3)
	{
		for (x = 1; x <= 9; x++)
		{
			N = temp;
			for (N; N <= M; N++)
				printf("\t%d * %d = %d\t", N, x, N*x);

			printf("\n");
		}
	}

	else if (lay == 4)
	{
		for (x = 1; x <= 9; x++)
		{
			N = temp;
			for (N; N <= M - 2; N++)
				printf("\t%d * %d = %d\t", N, x, N*x);

			printf("\n");
		}
		printf("\n");
		for (x = 1; x <= 9; x++)
		{
			N = temp;
			printf("\t");
			for (N += 3; N <= M; N++)
				printf("\t%d * %d = %d\t\t", N, x, N*x);

			printf("\n");
		}
	}

	else if (lay == 5)
	{
		for (x = 1; x <= 9; x++)
		{
			N = temp;
			for (N; N <= M - 3; N++)
				printf("\t%d * %d = %d\t", N, x, N*x);

			printf("\n");
		}
		printf("\n");
		for (x = 1; x <= 9; x++)
		{
			N = temp;
			for (N += 3; N <= M; N++)
				printf("\t%d * %d = %d\t", N, x, N*x);

			printf("\n");
		}
	}

	else if (lay == 6)
	{
		for (x = 1; x <= 9; x++)
		{
			N = temp;
			for (N; N <= M - 3; N++)
				printf("\t%d * %d = %d\t", N, x, N*x);

			printf("\n");
		}
		printf("\n");
		for (x = 1; x <= 9; x++)
		{
			N = temp;
			printf("\t");
			for (N += 4; N <= M; N++)
				printf("\t%d * %d = %d\t", N, x, N*x);

			printf("\n");
		}
	}

	else if (lay == 7)
	{
		for (x = 1; x <= 9; x++)
		{
			N = temp;
			for (N; N <= M - 4; N++)
				printf("\t%d * %d = %d\t", N, x, N*x);

			printf("\n");
		}
		printf("\n");
		for (x = 1; x <= 9; x++)
		{
			N = temp;
			for (N += 4; N <= M; N++)
				printf("\t%d * %d = %d\t", N, x, N*x);

			printf("\n");
		}
	}


	return 0;
}
