#include <iostream>
using namespace std;

void check(char *ary);

int main()
{
	char str[256];
	cin.getline(str, 256);

	check(str);
}

void check(char *ary) // 문자 갯수 확인 함수
{
	int i;
	char alpha[26];
	int num[26];

	for (i = 0; i < 26; i++)
	{
		alpha[i] = 'a' + i;
		num[i] = 0;
	}

	for (i = 0; ary[i] != 0; i++) // 문자열 끝까지 각각 확인
	{
		if ((ary[i] >= 'a') && (ary[i] <= 'z'))
			num[ary[i] - 'a']++;
	}
	for (i = 0; i < 26; i++)
		cout << alpha[i] << " : " << num[i]<<endl;
}