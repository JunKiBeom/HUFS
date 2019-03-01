#include <iostream>
using namespace std;

void mat9(int(*arr)[3]);
void mat25(int(*arr)[5]);
void mat49(int(*arr)[7]);


int main(void)
{
	int num = 1; // 배열의 값을 넣기 위해 사용
	int mat3[3][3] = { 0 }, mat5[5][5] = { 0 }, mat7[7][7] = { 0 };
	int col, row; // for문 제어 행,렬 변수

	for (col = 0; col < 3; col++)
	{
		for (row = 0; row < 3; row++)
			mat3[col][row] = num++;
	}
	num = 1; // 다음 출력을 위해 1로 초기화

	for (col = 0; col < 5; col++)
	{
		for (row = 0; row < 5; row++)
			mat5[col][row] = num++;	
	}
	num = 1;

	for (col = 0; col < 7; col++)
	{
		for (row = 0; row < 7; row++)
			mat7[col][row] = num++;
	}

	mat9(mat3);
	mat25(mat5);
	mat49(mat7);

	return 0;
}

void mat9(int(*arr)[3]) // 배열 회전 및 출력 함수
{
	int ary[3][3];
	int col, row;

	for (col = 0; col < 3; col++)
	{
		for (row = 0; row < 3; row++)
			ary[col][row] = arr[col][row]; // 배열 복사
	}

	for (col = 0; col < 3; col++)
	{
		for (row = 0; row < 3; row++)
			arr[col][row] = ary[row][2 - col];	// 회전
	}

	cout << endl;

	for (col = 0; col < 3; col++)
	{
		for (row = 0; row < 3; row++)
			cout << " " << arr[col][row] << "  "; // 출력
		cout << endl << endl;
	}
}

void mat25(int(*arr)[5])
{
	int ary[5][5];
	int col, row;

	for (col = 0; col < 5; col++)
	{
		for (row = 0; row < 5; row++)
			ary[col][row] = arr[col][row];
	}

	for (col = 0; col < 5; col++)
	{
		for (row = 0; row < 5; row++)
			arr[col][row] = ary[row][4 - col];
	}

	cout << endl;

	for (col = 0; col < 5; col++)
	{
		for (row = 0; row < 5; row++)
			cout << " " << arr[col][row] << "  ";
		cout << endl << endl;
	}
}

void mat49(int(*arr)[7])
{
	int ary[7][7];
	int col, row;

	for (col = 0; col < 7; col++)
	{
		for (row = 0; row < 7; row++)
			ary[col][row] = arr[col][row];
	}

	for (col = 0; col < 7; col++)
	{
		for (row = 0; row < 7; row++)
			arr[col][row] = ary[row][6 - col];
	}

	cout << endl;

	for (col = 0; col < 7; col++)
	{
		for (row = 0; row < 7; row++)
			cout << " " << arr[col][row] << "  ";
		cout << endl << endl;
	}
}
