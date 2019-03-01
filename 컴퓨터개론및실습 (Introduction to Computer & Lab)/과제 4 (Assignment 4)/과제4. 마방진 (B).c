#include<stdio.h>
#pragma warning (disable:4996)
void mabangjin()
{
	int i, j, m;
	int r, c;
	int next_r, next_c;   //다음에 올 숫자
	int n; //출력 될 숫자

	printf("Input size of board : ");
	scanf("%d", &m);
	printf("\n");
	if (m % 2 == 0)
		m = m + 1; // 칸 수를 홀수만 받으므로 짝수를 입력받으면 홀수로 바꿔서 출력

	int print[10][10] = { 0 };

	for (i = 0; i<m; i++)
	{
		for (j = 0; j<m; j++)
			print[i][j] = 0;
	}

	r = m - 1; //첫 좌표 위치 설정
	c = m / 2;
	n = 1; //처음 출력 될 숫자는 1

	while (1)
	{
		print[r][c] = n; //해당하는 위치의 좌표에 숫자를 채워 넣음

		for (i = 0; i<m; i++)
		{
			for (j = 0; j<m; j++)
			{
				if (print[i][j] == 0)   //좌표에 0이 들어가지 않도록 반복문 생성
					break;
			}
			if (j != m)
				break;   //해당하는 크기를 벗어나지 않도록 설정
		}
		if (i == m && j == m)   //좌표가 모두 채워지도록 설정
			break;

		next_r = r + 1;   //영역을 벗어 날 경우 방법
		next_c = c + 1;

		if (next_r > m - 1 && next_c > m - 1)
		{
			next_r = r - 1;
			next_c = c;
		}
		else if (next_r > m - 1)
			next_r = 0;
		else if (next_c > m - 1)
			next_c = 0;   //해당하는 좌표가 채워져 있으면 그 좌표의 위칸에 다음 숫자를 채운다

		if (print[next_r][next_c])
		{
			next_r = r - 1;
			next_c = c;   //숫자 넣고 다음 숫자에 +1을 한 다음
		}
		print[next_r][next_c] = n++;
		r = next_r;
		c = next_c; //좌표 갱신한 후 다음을 수행
	}   //결과 출력 후 종료

	for (i = 0; i<m; i++)
		for (j = 0; j < m; j++)
		{
			print[i][m] += print[i][j]; // 가로합
			print[m][j] += print[j][i]; // 세로합
		}

	for (i = 0; i <= m; i++)
	{
		for (j = 0; j <= m; j++)
		{
			if (print[i][j] == 0)
				continue;
			printf("%d\t", print[i][j]);   //결과 값을 출력
		}
		printf("\n");
	}
}

int main(){
	mabangjin();

	return 0;
}