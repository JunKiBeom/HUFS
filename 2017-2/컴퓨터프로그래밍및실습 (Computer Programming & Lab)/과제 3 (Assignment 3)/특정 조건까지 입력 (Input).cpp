#include <iostream>
using namespace std;

int main()
{
	int i, count = 0, calc = 0; // count는 몇번의 입력을 받았는지 확인하는 횟수, calc는 입력받은 배열의 합 저장
	int *arr = 0, *temp = 0; // 동적할당을 위한 포인터
	int stop = -2147483648LL; // -2147483648 입력시 프로그램 종료, long long형으로 형변환
	for (i = 1;; i++)
	{
		arr = new int[i]; // i의 반복만큼 크기 동적할당

		if (i > 1) // 1보다 클 경우 temp내용 arr로 옮김
			for (int j = 0; j < i - 1; j++)
				arr[j] = temp[j];

		delete[] temp; // 사용 후 반납
		temp = new int[i]; // i의 반복만큼 크기 동적할당

		if (i > 1) // arr의 내용 temp에 저장
			for (int j = 0; j < i - 1; j++)
				temp[j] = arr[j];

		cin >> arr[i - 1]; // arr 입력받음

		if (arr[i - 1] == stop) // arr의 값이 -2147483648일 경우 입력 받은 값 모두 합산, for문 탈출
		{
			for (int i = 0; i < count; i++)
				calc += temp[i];
			break;
		}

		else  // 그렇지 않으면 count +1, temp에 arr값 저장
		{
			count++;
			temp[i - 1] = arr[i - 1];
			delete[] arr; // 사용 후 반납
		}
	}
	cout << calc << endl; // 합산한 값 출력
}
