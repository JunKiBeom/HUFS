#include <iostream>
using namespace std;

void splitString(char *str, char delim);

int main()
{
	char str[256]; // 입력받을 문자열
	cin.getline(str, 256);

	splitString(str, ' ');
	cout << endl;
}

void splitString(char *ary, char delim) // 포인터로 문자열 받고 공백시 다음 줄 출력
{
	int i;
	for (i = 0; i < 256; i++)
	{
		if (ary[i] == '\0') // \0인 null문자 도달시 중지
			break;
		else if (ary[i] == delim) // 조건과 같을 경우 다음줄로 줄바꿈
			cout << endl;
		else
			cout << ary[i];
	}
}
