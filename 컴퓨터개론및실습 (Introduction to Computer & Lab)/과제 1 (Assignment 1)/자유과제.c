#include <stdio.h>
#pragma warning (disable:4996)

int main()
{
	int a, b, c; // 정수 a, b, c 3개를 받는다
	printf("숫자 3개를 입력하시오 : "); // 구문을 출력
	scanf("%d %d %d", &a, &b, &c); // 정수를 받게 하는 구문
	printf(" a는 %d\n b는 %d\n c는 %d\n", a, b, c); // 받은 값을 출력

	if (a > b) // a가 b보다 클 경우
	{
		printf("가장 큰 수는 %d\n", a); // a값을 출력
	}
	else if (b > c) // b가 c보다 클 경우
	{
		printf("가장 큰 수는 %d\n", b); // b값을 출력
	}
	else if (a > c) // a가 c보다 클 경우
	{
		printf("가장 큰 수는 %d\n", a); // a값 출력
	}
	else
		printf("가장 큰 수는 %d\n", c); // 위 조건에 모두 부합하지 않으면 c값을 출력

	printf("201703091 전기범\n"); //학번 이름 출력
	return 0;
}
