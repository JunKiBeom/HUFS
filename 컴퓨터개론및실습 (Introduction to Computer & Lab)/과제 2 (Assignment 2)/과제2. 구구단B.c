#include <stdio.h>
#pragma warning (disable:4996)
int main(void)
{
	int i, n, m, N;
	printf("몇 단 부터 몇 단 까지을 표시할까요? ");
	scanf("%d %d", &n, &m);
	N = n;

	switch (m-n)
	{
		case 1:
			for (i = 1; i < 10; i++)
			{
				n = N;
				for (n; n <= m; n++)
					printf("%d * %d = %d \t", n, i, n*i);
				printf("\n");
			}
			break;

		case 2:
			for (i = 1; i < 10; i++)
			{
				n = N;
				for (n; n <= m - 1; n++)
					printf("%d * %d = %d \t", n, i, n*i);
				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 2; n <= m; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			break;

		case 3:
			for (i = 1; i < 10; i++)
			{
				n = N;
				for (n; n <= m - 2; n++)
					printf("%d * %d = %d \t", n, i, n*i);
				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 2; n <= m; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			break;

		case 4:
			for (i = 1; i < 10; i++)
			{
				n = N;
				for (n; n <= m - 3; n++)
					printf("%d * %d = %d \t", n, i, n*i);
				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 2; n <= m - 1; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 4; n <= m; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			break;

		case 5:
			for (i = 1; i < 10; i++)
			{
				n = N;
				for (n; n <= m - 4; n++)
					printf("%d * %d = %d \t", n, i, n*i);
				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 2; n <= m - 2; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 4; n <= m; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			break;

		case 6:
			for (i = 1; i < 10; i++)
			{
				n = N;
				for (n; n <= m - 5; n++)
					printf("%d * %d = %d \t", n, i, n*i);
				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 2; n <= m - 3; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 4; n <= m - 1; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 6; n <= m; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			break;

		case 7:
			for (i = 1; i < 10; i++)
			{
				n = N;
				for (n; n <= m - 6; n++)
					printf("%d * %d = %d \t", n, i, n*i);
				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 2; n <= m - 4; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 4; n <= m - 2; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			printf("\n");
			for (int i = 1; i < 10; i++)
			{
				n = N;
				for (n += 6; n <= m; n++)
					printf("%d * %d = %d \t", n, i, n*i);

				printf("\n");
			}
			break;

	}
	return 0;
}