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

	while (1) // �빮�� �Է� �޾��� ��� �ٽ� �Է�
	{
		int temp = 0;
		printf("Word?\t");
		fgets(first, 100, stdin); // ���� ����
		first[strlen(first) - 1] = '\0'; // \n�� \0���� �����
		for (int index = 0; index < strlen(first); index++)
		{
			if (isupper(first[index]))
			{
				printf("Only Input Small Letter\n");
				temp = 1;
				break;
			}
		}
		if (!temp) // �ҹ����̸� �ݺ��� Ż��
			break;
	} //

	while (1) // ��ü �ݺ�
	{
		int index1 = 0, index2 = 0;
		while (1) // �빮�� �Է� �޾��� ��� �ٽ� �Է�
		{
			int temp = 0;
			printf("Word?\t");
			fgets(second, 100, stdin); // ���� ����
			second[strlen(second) - 1] = '\0'; // \n�� \0���� �����

			for (int index = 0; index < strlen(second); index++)
			{
				if (isupper(second[index]))
				{
					printf("Only Input Small Letter\n");
					temp = 1;
					break;
				}
			}
			if (!temp) // �ҹ����̸� �ݺ��� Ż��
				break;
		} // 

		for (index1 = 0; index1 < strlen(first); index1++) // ��� for��
		{
			for (index2 = 0; index2 < strlen(second); index2++)
			{
				if ((!strcmp(first, "end")) || (!strcmp(second, "end"))) // end �Է½� ����
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
		
		printf("\n\"Next : %s /  \"\n\n", second); // ������ ���� ���� �����ֱ�

		strcpy(first, second); // first�� second �� ����

	}
}