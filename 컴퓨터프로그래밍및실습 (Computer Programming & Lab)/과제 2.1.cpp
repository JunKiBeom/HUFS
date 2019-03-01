#include <iostream>
using namespace std;

int num = 0; // 문자열 길이 계산 변수

void str(char *ary);

int main()
{
	char arr[256]; // 입력받을 문자열
	cin.getline(arr, 256);

	str(arr);
	cout << num << endl;
}

void str(char *ary) // 포인터로 문자열 받고 길이 계산
{
	int i;
	for (i = 0; i < 256; i++)
	{
		if (ary[i] == '\0') // \0인 null문자 도달시 중지
			break;
		else
			num++;
	}
}