#include <stdio.h>
#include <math.h> // sin cos �Լ� �������� ���

#define PI 3.1415926535897932384626433832795028841971 // �׷����� ���е��� ���̱� ����

void graph(void) // sin���� �׷����� ����ϴ� �Լ� 
{
	double sinx, cosx; // sin_degree ���� ���� ����
	int degree, line;
	
	for (degree = 0; degree <= 360; degree += 9)
	{
		for (line = 0; line < 50; line++) // �� ���
			printf(" ");
		printf("|\n");

		sinx = sin((degree*(PI / 180))); // sin�� ���Ȱ� �־���
		for (line = -50; line < sinx * 50; line++) // sin�� ��ŭ �����
			printf(" ");
		printf("*\n"); // �׷��� ��� �ٹٲ�

		cosx = cos((degree*(PI / 180))); // cos�� ���Ȱ� �־���
		for (line = -50; line < cosx * 50; line++) // cos�� ��ŭ �����
			printf(" ");
		printf("+\n"); // �׷��� ��� �ٹٲ�
	}

}

int main(void)
{
	graph();
	return 0;
}