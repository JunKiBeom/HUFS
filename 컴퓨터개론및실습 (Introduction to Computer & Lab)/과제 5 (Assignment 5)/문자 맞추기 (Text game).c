#include <stdio.h>
#include <string.h>
#include <ctype.h>
#pragma warning (disable:4996)
int main()
{
	char first[100] = { 0 }, second[100] = { 0 };
	char savef[100] = { 0 }, saves[100] = { 0 };
	int len = 0, ncount = 0;
	int save1 = 0 , save2 = 0;

	while (1) // 대문자 입력 받았을 경우 다시 입력
	{
		int temp = 0;
		printf("Word?\t");
		fgets(first, 100, stdin); // 길이 지정
		first[strlen(first) - 1] = '\0'; // \n을 \0으로 만들기
		for (int index = 0; index < strlen(first); index++)
		{
			if (isupper(first[index]))
			{
				printf("Only Input Small Letter\n");
				temp = 1;
				break;
			}
		}
		if (!temp) // 소문자이면 반복문 탈출
			break;
	} //

	while (1) // 전체 반복
	{
		int index1 = 0, index2 = 0;
		while (1) // 대문자 입력 받았을 경우 다시 입력
		{
			int temp = 0;
			printf("Word?\t");
			fgets(second, 100, stdin); // 길이 지정
			second[strlen(second) - 1] = '\0'; // \n을 \0으로 만들기

			for (int index = 0; index < strlen(second); index++)
			{
				if (isupper(second[index]))
				{
					printf("Only Input Small Letter\n");
					temp = 1;
					break;
				}
			}
			if (!temp) // 소문자이면 반복문 탈출
				break;
		} // 

		for (index1 = 0; index1 < strlen(first); index1++) // 출력 for문
		{
			for (index2 = 0; index2 < strlen(second); index2++)
			{
				if ((!strcmp(first, "end")) || (!strcmp(second, "end"))) // end 입력시 종료
				{
					exit(1);
					continue;
				}

				else if (first[index1] == second[index2])
				{
					for (int index3 = index1; index3 >= 1; index3--)
						printf("%c", first[index1 - index3]);

					printf("(%c)", first[index1]);

					for (int index3 = index1 + 1; index3 < strlen(first); index3++)
						printf("%c", first[index3]);

					printf("  +  ");

					for (int index3 = index2; index3 >= 1; index3--)
						printf("%c", second[index2 - index3]);

					printf("(%c)", second[index2]);

					for (int index3 = index2 + 1; index3 < strlen(second); index3++)
						printf("%c", second[index3]);

					printf("\n");
					break;
				} //

				else if ((index1 == strlen(first)-1) && (index2 == strlen(second)-1))
				{
					printf("No Cross Word!!\n\n");
					break;
				}
			} //
		} //
		
		printf("\n\"Next : %s /  \"\n\n", second); // 다음에 비교할 글자 보여주기

		strcpy(first, second); // first에 second 값 넣음

	}
}
