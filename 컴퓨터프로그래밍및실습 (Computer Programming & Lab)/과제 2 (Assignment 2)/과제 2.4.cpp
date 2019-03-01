#include<iostream>
using namespace std;

int len = 0; // len = arr 문자열의 길이 접근을 위하여 전역변수로 선언

int isPalindrome(char* arr);

int main()
{
	char str[256];
	char *ps = 0, *pe = 0; // *ps는 문자열의 시작 주소, *pe는 문자열의 끝 주소
	cin >> str;
	ps = &str[0];
	for (int i = 0; i<256; i++)
		if (str[i] == '\0')
		{
			pe = &str[i];
			break;
		}
	len = pe - ps;
	isPalindrome(str);
}

int isPalindrome(char* arr) // 회문 판단 프로그램
{
	int i, count = 0;  // count는 회문 여부 판단 변수

	for (i = 0; i < len / 2; i++) // len의 절반만 for문 돎
	{
		if (arr[i] != arr[len - i - 1]) // 문자열의 길이-i-1과 현재 판단중인 문자열의 i번째가 같지 않다면 카운트 안올라감
			count = count;
		else if (arr[i] == arr[len - i - 1]) // 같다면 카운트 1증가
			count++;
	}
	if (count != len / 2) // count가 len/2 와 같지 않다면 회문 아님
		cout << "not palindrome" << endl;
	else if (count == len / 2) // count와 len/2가 같다면 회문
		cout << "palindrome" << endl;

	return 0;
}