#include <iostream>
#include <cmath>
using namespace std;


double arr[10000] = { 0, }; // 접근 용이성을 위해 전역변수 선언, 결과값 저장 배열
void sort(int num); // 정렬 후 출력

int main()
{
	int a, b;
	int num = 0;
	cin >> a >> b; // 끝 범위 입력 받기

	for (int i = 2; i <= a; i++) // 계산결과 넣기
		for (int j = 2; j <= b; j++)
		{
			arr[num] = pow(i, j);
			num++;
		}

	sort(num);

	cout << endl;
	/*for (int i = 0; i < num; i++)
		cout << arr[i] << " ";*/
}

void sort(int num) // 정렬 함수
{
	int i, j, count = 0;
	double temp;

	for (i = num - 1; i >= 0; i--)  // 정렬할 데이터의 범위
		for (j = 0; j < i; j++)         // 정렬할 데이터
			if (arr[j] > arr[j + 1])  // 인접한 데이터 중 왼쪽이 더 크면
			{
				temp = arr[j];        // 인접한 데이터를 서로 바꾼다.
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
			}

	for (i = 0; i < num; i++) // 카운팅
	{
		if (arr[i] == arr[i + 1])
			continue;
		else
			count++;
	}
	cout << count << endl;
}