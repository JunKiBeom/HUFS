#include <stdio.h>
#include <string.h>
#pragma warning (disable:4996)
struct BOOK
{
	int num;
	char title[21];
	char author[6];
	char date[9];
};

int main()
{
	char name[10] = { 0 };
	struct BOOK book[5] = { { 1, "c program", "Rit", "20170606" }, { 2, "calculus", "Tom", "20170606" }, { 3, "physics", "John", "20170606" }, { 4, "chemistry", "Murry", "20170606" }, { 5, "minerva", "HUFS", "20170606" } };
	
	while (1) // 대문자 입력 받았을 경우 다시 입력
	{
		int temp = 0;
		printf("Tilte? \t");
		gets(name);
		for (int index = 0; index < strlen(name); index++)
		{
			if (isupper(name[index]))
			{
				printf("Only Input Small Letter\n");
				temp = 1;
				break;
			}
		}
		if (!temp) // 소문자이면 반복문 탈출
			break;
	} //

	for (int i = 0; i < 5; i++)
	{
		if (strstr(book[i].title, name) != 0)
			printf("No.%d  title : %2s  Author : %2s  Date : %2s\n", book[i].num, book[i].title, book[i].author, book[i].date);
	}
}