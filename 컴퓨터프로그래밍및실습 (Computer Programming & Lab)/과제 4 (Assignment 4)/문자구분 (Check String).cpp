#include <iostream>
using namespace std;

int main()
{
	char arr[10000]; // 문자열 입력 받을 배열
	int Bcnt = 0, Lcnt = 0, Ncnt = 0, Scnt = 0; // 대문자, 소문자, 공백문자, 특수문자 카운트 변수

	cin.getline(arr, 10000);

	for (int i = 0; arr[i] != 0; i++) // NULL문자 까지 for문 반복
	{
		if ((arr[i] >= '!') && (arr[i] <= '@')) // 특수문자일경우
			Scnt++;
		else if ((arr[i] >= '[') && (arr[i] <= '`')) // 특수문자일경우
			Scnt++;
		else if ((arr[i] >= '{') && (arr[i] <= '~')) // 특수문자일경우
			Scnt++;
		else if ((arr[i] >= 'A') && (arr[i] <= 'Z')) // 대문자일경우
			Bcnt++;
		else if ((arr[i] >= 'a') && (arr[i] <= 'z')) // 소문자일경우
			Lcnt++;
		else if (arr[i] == ' ') // 공백일경우
			Ncnt++;
	}
	cout << Bcnt << " " << Lcnt << " " << Ncnt << " " << Scnt << endl;
}
