#include <iostream>
#include <math.h>
using namespace std;

int arr[16] = { 0 }; // 접근 용이성을 위해 전역변수 선언, 결과값 저장 배열
void print(); // 계산 출력
void sort(); // 정렬 후 출력

int main()
{
	int a, b, ar[4] = { 2, 3, 4, 5 }, br[4] = { 2, 3, 4, 5 }, num = 0; // ar,br은 값 계산을 위한 배열

	print();

	for (a = 0; a < 4; a++) // 계산결과 넣기
		for (b = 0; b < 4; b++)
		{
			arr[num] = pow(ar[a], br[b]);
			num++;
		}

	sort();

	cout << endl;
}

void print() // 출력 함수
{
	int a, b;
	for (a = 2; a < 6; a++)
	{
		for (b = 2; b < 6; b++)
		{
			cout << a << "^" << b << "=" << pow(a, b);

			if (b == 5) // a^5 값 뒤에 , 출력 안하게 하기
			{
				continue;
				cout << ", ";
			}
			else
				cout << ", " << "  ";
		}
		cout << endl; // a값 증가에 따른 줄 바꿈
	}
	cout << endl;
}

void sort() // 정렬 함수
{
	int i, j, temp, count = 0;

	for (i = 15; i >= 0; i--)     // 정렬할 데이터의 범위
		for (j = 0; j < i; j++)         // 정렬할 데이터
			if (arr[j] > arr[j + 1])  // 인접한 데이터 중 왼쪽이 더 크면
			{
				temp = arr[j];        // 인접한 데이터를 서로 바꾼다.
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
			}

	for (i = 0; i < 16; i++) // 카운팅
	{
		if (arr[i] == arr[i + 1])
			continue;
		else
			count++;
	}
	cout << endl << "Count = " << count << endl;

	for (i = 0; i < 16; i++) // 출력
	{
		if (arr[i] == arr[i + 1])
			continue;

		else
		{
			cout << arr[i];
			if (arr[i] == 3125) // 마지막 값 뒤에 , 출력 안하게 하기
				continue;
			else
				cout << ", ";
		}
		
	}
}
