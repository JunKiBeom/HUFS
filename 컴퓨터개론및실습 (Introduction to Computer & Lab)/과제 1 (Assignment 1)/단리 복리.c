#include <stdio.h>
#pragma warning (disable:4996)

int main() {
	int principal;
	float interest;

	printf("������ �Է��ϼ��� : ");
	scanf("%d", &principal);
	printf("�ݸ��� �Է��ϼ��� : ");
	scanf("%f", &interest);

	printf("���� %d�� �ݸ� %.0f%% �Դϴ�.\n ", principal, interest);

	interest = interest / 100;

	float _1Y = principal + principal*interest;

	printf("�Ⱓ   �ܸ�   ����\n");
	printf(" 1��   %.2f   %.2f\n", _1Y, _1Y);
	printf(" 2��   %.2f   %.2f\n", principal + (principal*interest) * 2, _1Y + _1Y * interest);

	float _2Y = _1Y + _1Y * interest;

	printf(" 3��   %.2f   %.2f\n", principal + (principal*interest) * 3, _2Y + _2Y * interest);

	float _3Y = _2Y + _2Y * interest;

	printf(" 4��   %.2f   %.2f\n", principal + (principal*interest) * 4, _3Y + _3Y * interest);

	float _4Y = _3Y + _3Y*interest;

	printf(" 5��   %.2f   %.2f\n\n", principal + (principal*interest) * 5, _4Y + _4Y *interest);

	printf("201703091 �����\n");
	return 0;
}