#include <stdio.h>
#pragma warning (disable:4996)

int main()
{
	int a, b, c; // ���� a, b, c 3���� �޴´�
	printf("���� 3���� �Է��Ͻÿ� : "); // ������ ���
	scanf("%d %d %d", &a, &b, &c); // ������ �ް� �ϴ� ����
	printf(" a�� %d\n b�� %d\n c�� %d\n", a, b, c); // ���� ���� ���

	if (a > b) // a�� b���� Ŭ ���
	{
		printf("���� ū ���� %d\n", a); // a���� ���
	}
	else if (b > c) // b�� c���� Ŭ ���
	{
		printf("���� ū ���� %d\n", b); // b���� ���
	}
	else if (a > c) // a�� c���� Ŭ ���
	{
		printf("���� ū ���� %d\n", a); // a�� ���
	}
	else
		printf("���� ū ���� %d\n", c); // �� ���ǿ� ��� �������� ������ c���� ���

	printf("201703091 �����\n"); //�й� �̸� ���
	return 0;
}