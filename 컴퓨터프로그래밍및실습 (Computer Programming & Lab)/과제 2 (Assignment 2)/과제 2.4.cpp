#include<iostream>
using namespace std;

int len = 0; // len = arr ���ڿ��� ���� ������ ���Ͽ� ���������� ����

int isPalindrome(char* arr);

int main()
{
	char str[256];
	char *ps = 0, *pe = 0; // *ps�� ���ڿ��� ���� �ּ�, *pe�� ���ڿ��� �� �ּ�
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

int isPalindrome(char* arr) // ȸ�� �Ǵ� ���α׷�
{
	int i, count = 0;  // count�� ȸ�� ���� �Ǵ� ����

	for (i = 0; i < len / 2; i++) // len�� ���ݸ� for�� ��
	{
		if (arr[i] != arr[len - i - 1]) // ���ڿ��� ����-i-1�� ���� �Ǵ����� ���ڿ��� i��°�� ���� �ʴٸ� ī��Ʈ �ȿö�
			count = count;
		else if (arr[i] == arr[len - i - 1]) // ���ٸ� ī��Ʈ 1����
			count++;
	}
	if (count != len / 2) // count�� len/2 �� ���� �ʴٸ� ȸ�� �ƴ�
		cout << "not palindrome" << endl;
	else if (count == len / 2) // count�� len/2�� ���ٸ� ȸ��
		cout << "palindrome" << endl;

	return 0;
}