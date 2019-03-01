#include <stdio.h>
#include <string.h>
#pragma warning (disable:4996)
#define NUM(X) (X==0? 0:X-'0')

void reverse(char *arr, int len);

int main()
{
	int len = 0, i = 0, up = 0, down = 0;
	char calc[5][200] = { 0 }; // 배열 5개 (X,Y,덧셈,뺄셈,곱셈)
	printf("Input X : ");
	gets(calc[0]);
	printf("Input Y : ");
	gets(calc[1]);

	if (strlen(calc[0])>strlen(calc[1])) 	// 큰 수의 길이를 len이란 변수에 넣음
	{
		len = strlen(calc[0]);
	}
	else len = strlen(calc[1]);

	reverse(calc[0], strlen(calc[0]));	// 배열 뒤집기
	reverse(calc[1], strlen(calc[1]));
	
	for (i = 0; i <= len; i++) // 덧셈
	{
		calc[2][i] = (NUM(calc[0][i]) + NUM(calc[1][i]) + up) % 10 + '0';
		if ((NUM(calc[0][i]) + NUM(calc[1][i]) + up)>9) up = 1;
		else up = 0;
	}
	
	if (calc[2][len] == '0') calc[2][len] = 0; // 맨 뒷자리 0이면 값 삭제
	
	reverse(calc[2], strlen(calc[2])); // 원래의 값을 보여주기 위해 뒤집기
	if (calc[2][0] == '*') calc[2][0] = '-';

	printf("X + Y = %s\n", calc[2]);
	
	for (i = 0; i <= len; i++) // 뺄셈
	{
		calc[3][i] = (NUM(calc[0][i]) - NUM(calc[1][i]) + down) % 10 + '0';
		if ((NUM(calc[0][i]) - NUM(calc[1][i]) + down)<0) down = -1;
		else down = 0;

		switch (calc[3][i]) // 아스키코드 처리
		{
			case 39 :
			calc[3][i] = 49;
			break;
		case 40 :
			calc[3][i] = 50;
			break;
		case 41 :
			calc[3][i] = 51;
			break;
		case 42 :
			calc[3][i] = 52;
			break;
		case 43 :
			calc[3][i] = 53;
			break;
		case 44 :
			calc[3][i] = 54;
			break;
		case 45 :
			calc[3][i] = 55;
			break;
		case 46 :
			calc[3][i] = 56;
			break;
		case 47 :
			calc[3][i] = 57;
			break;
		}
	}
	
	if (calc[3][len] == '0') calc[3][len] = 0; // 맨 뒷자리 0이면 값 삭제
	
	if (calc[3][len-1] == '0') calc[3][len-1] = 0; // 받아 내림하여 맨 앞자리 값이 0이 될경우 값 삭제
	
	reverse(calc[3], strlen(calc[3])); // 뒤집기
	if (calc[3][0] == '0') calc[3][0] = '-';
	printf("X - Y = %s\n", calc[3]);

	//곱셈
	printf("X * Y = %s\n", calc[4]);
	return 0;
}

void reverse(char *arr, int len) // 배열 뒤집기
{
	char temp;
	int i;
	for (i = 0; i < len / 2; i++)
	{
		temp = arr[i];
		arr[i] = arr[len - 1 - i];
		arr[len - 1 - i] = temp;
	}
}