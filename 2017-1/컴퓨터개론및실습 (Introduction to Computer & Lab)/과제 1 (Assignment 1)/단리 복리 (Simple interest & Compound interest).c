#include <stdio.h>
#pragma warning (disable:4996)

int main() {
	int principal;
	float interest;

	printf("원금을 입력하세요 : ");
	scanf("%d", &principal);
	printf("금리를 입력하세요 : ");
	scanf("%f", &interest);

	printf("원금 %d원 금리 %.0f%% 입니다.\n ", principal, interest);

	interest = interest / 100;

	float _1Y = principal + principal*interest;

	printf("기간   단리   복리\n");
	printf(" 1년   %.2f   %.2f\n", _1Y, _1Y);
	printf(" 2년   %.2f   %.2f\n", principal + (principal*interest) * 2, _1Y + _1Y * interest);

	float _2Y = _1Y + _1Y * interest;

	printf(" 3년   %.2f   %.2f\n", principal + (principal*interest) * 3, _2Y + _2Y * interest);

	float _3Y = _2Y + _2Y * interest;

	printf(" 4년   %.2f   %.2f\n", principal + (principal*interest) * 4, _3Y + _3Y * interest);

	float _4Y = _3Y + _3Y*interest;

	printf(" 5년   %.2f   %.2f\n\n", principal + (principal*interest) * 5, _4Y + _4Y *interest);

	printf("201703091 전기범\n");
	return 0;
}
