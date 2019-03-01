#include <iostream>
using namespace std;

int main()
{
	int num;
	int a, b;
	int i, cnt = 0;
	char alp = 'A';

	cin >> num;
	num = (num / 2.0 + 0.5); // 상 하단 출력을 위한 수식

	if (num % 2 == 0) // num이 짝수일때(7+4n)
	{
		for (i = 0; i < num + 1; i++) // 마름모 상단 출력
		{
			for (a = num - 1; a > cnt; a--) // 공백 출력
				cout << " ";
			for (b = 0; b <= cnt; b++)
			{
				if (b % 2 == 0) // 짝수 자리일때 출력
				{
					if (alp > 'Z')
						alp = 'A';
					cout << alp << " ";
					alp++;
				}
				else // 홀수 자리일때 공백 출력
					cout << "  ";

			}
			cout << endl;
			cnt++; // 제어 카운트 증가

			if (cnt >= num) // 카운트가 숫자보다 커지면 반복문 종료
				break;
		}
	}
	else // num이 홀수일때 (5+4n)
	{
		for (i = 0; i < num + 1; i++) // 마름모 상단 출력
		{
			for (a = num - 1; a > cnt; a--) // 공백 출력
				cout << " ";
			for (b = 0; b <= cnt; b++)
			{
				if (b % 2 == 0) // 짝수 자리일때 출력
				{
					if (alp > 'Z')
						alp = 'A';
					cout << alp << " ";
					alp++;
				}
				else // 홀수 자리일때 공백 출력
					cout << "  ";
			}
			cout << endl;
			cnt++; // 제어 카운트 증가

			if (cnt >= num) // 카운트가 숫자보다 커지면 반복문 종료
				break;
		}
	}
	int ncnt = num;
	int mcnt = num - 1;
	int dcnt = 0; // 하단부 출력을 위한 변수 선언

	if (num % 2 == 0) // num이 짝수일때(7+4n)
	{
		for (i = 0; i < num - 2; i++) // 하단부 출력
		{
			int temp = i;
			if (temp / 2 > 0 && temp % 2 == 0)
				dcnt -= 4;
			for (a = 3; a > dcnt; a--)
				cout << " ";
			int run = mcnt / 2;
			while (run > 0)
			{
				if (alp > 'Z')
					alp = 'A';
				cout << alp;
				alp++;
				if (run != 1) // 그 줄의 마지막 문자 출력이 아닐경우
				{
					for (a = 0; a < 3; a++)
						cout << " ";
				}
				else // 그 줄의 마지막 문자 출력일 경우
				{
					for (a = 0; a < 3; a++)
						cout << " ";
				}
				run--;
			}
			cout << endl;
			mcnt--;
			dcnt++;
		}
	}
	else // num이 홀수일때 (5+4n)
	{
		for (i = 0; i < num - 1; i++) // 하단부 출력
		{
			int temp = i;
			if (temp / 2 > 0 && temp % 2 == 0)
				dcnt -= 4;
			for (a = 3; a > dcnt; a--)
				cout << " ";
			int run = ncnt / 2;
			while (run > 0)
			{
				if (alp > 'Z')
					alp = 'A';
				cout << alp;
				alp++;
				if (run != 1) // 그 줄의 마지막 문자 출력이 아닐경우
				{
					for (a = 0; a < 3; a++)
						cout << " ";
				}
				else // 그 줄의 마지막 문자 출력일 경우
				{
					if (num == 5) // 9 입력시 하단부 뒤에 공백 1개 
						for (a = 0; a < 1; a++)
							cout << " ";
					else // 다른수 일경우 공백 3개
						for (a = 0; a < 3; a++)
							cout << " ";
				}
				run--;
			}
			cout << endl;
			ncnt--;
			dcnt++;
		}
	}
}