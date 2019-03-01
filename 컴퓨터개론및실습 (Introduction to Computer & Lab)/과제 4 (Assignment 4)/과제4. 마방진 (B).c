#include<stdio.h>
#pragma warning (disable:4996)
void mabangjin()
{
	int i, j, m;
	int r, c;
	int next_r, next_c;   //������ �� ����
	int n; //��� �� ����

	printf("Input size of board : ");
	scanf("%d", &m);
	printf("\n");
	if (m % 2 == 0)
		m = m + 1; // ĭ ���� Ȧ���� �����Ƿ� ¦���� �Է¹����� Ȧ���� �ٲ㼭 ���

	int print[10][10] = { 0 };

	for (i = 0; i<m; i++)
	{
		for (j = 0; j<m; j++)
			print[i][j] = 0;
	}

	r = m - 1; //ù ��ǥ ��ġ ����
	c = m / 2;
	n = 1; //ó�� ��� �� ���ڴ� 1

	while (1)
	{
		print[r][c] = n; //�ش��ϴ� ��ġ�� ��ǥ�� ���ڸ� ä�� ����

		for (i = 0; i<m; i++)
		{
			for (j = 0; j<m; j++)
			{
				if (print[i][j] == 0)   //��ǥ�� 0�� ���� �ʵ��� �ݺ��� ����
					break;
			}
			if (j != m)
				break;   //�ش��ϴ� ũ�⸦ ����� �ʵ��� ����
		}
		if (i == m && j == m)   //��ǥ�� ��� ä�������� ����
			break;

		next_r = r + 1;   //������ ���� �� ��� ���
		next_c = c + 1;

		if (next_r > m - 1 && next_c > m - 1)
		{
			next_r = r - 1;
			next_c = c;
		}
		else if (next_r > m - 1)
			next_r = 0;
		else if (next_c > m - 1)
			next_c = 0;   //�ش��ϴ� ��ǥ�� ä���� ������ �� ��ǥ�� ��ĭ�� ���� ���ڸ� ä���

		if (print[next_r][next_c])
		{
			next_r = r - 1;
			next_c = c;   //���� �ְ� ���� ���ڿ� +1�� �� ����
		}
		print[next_r][next_c] = n++;
		r = next_r;
		c = next_c; //��ǥ ������ �� ������ ����
	}   //��� ��� �� ����

	for (i = 0; i<m; i++)
		for (j = 0; j < m; j++)
		{
			print[i][m] += print[i][j]; // ������
			print[m][j] += print[j][i]; // ������
		}

	for (i = 0; i <= m; i++)
	{
		for (j = 0; j <= m; j++)
		{
			if (print[i][j] == 0)
				continue;
			printf("%d\t", print[i][j]);   //��� ���� ���
		}
		printf("\n");
	}
}

int main(){
	mabangjin();

	return 0;
}