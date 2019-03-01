#include <stdio.h>
#include <math.h>
#define PI 3.1415926535
#define Rad PI / 180
#pragma warning (disable:4996)
void _5C()
{
	char board[200][200] = { 0 }; // 초기화하지 않으면 이상한 문자들이 나오므로 초기화
	int x, y, i, j, r = 12;
	int X[5] = { 15, 25, 35, 45, 55 }, Y[5] = { 8, 16, 8, 16, 8 }; // 5개 원을 그리기 위해 선언.
	double sinX, cosX;
	double c_X, c_Y;

	for (x = 0; x < 100; x++)
		for (y = 0; y < 100; y++)
			for (i = 0; i < 5; i++)
				for (j = 0; j <= 360; j++)
				{
					sinX = sin(Rad * j);
					cosX = cos(Rad * j);
					c_X = r * (1 - cosX); // if 안에 짧게 쓰기 위해 사용. 회전변환식.
					c_Y = r * (1 - sinX);
					if ((x <= X[i] + c_X + 1 && x >= X[i] + c_X - 1) && (y <= Y[i] + c_Y + 1 && y >= Y[i] + c_Y - 1))
						board[x][y] = '*';
				}
	for (x = 0; x < 100; x++)
		for (y = 0; y < 100; y++)
			printf("%c", board[x][y]); // 오륜기 출력

}
int main()
{
	_5C();
}
