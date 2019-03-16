#include <iostream>
#include <cstring> // strcmp사용
using namespace std;

int up, down; // 분자 분모 계산값, 접근의 용이성을 고려하여 전역변수로 선언함

void add(struct num1 a, struct num2 b);
void sub(struct num1 a, struct num2 b);
void multi(struct num1 a, struct num2 b);
void div(struct num1 a, struct num2 b);
int GCD(int num1, int num2);

struct num1
{
	int up1;
	int down1;
};

struct num2
{
	int up2;
	int down2;
};

int main()
{
	char opr[6]; // 연산자
	struct num1 a;
	struct num2 b;

	cin >> a.up1 >> a.down1;
	cin >> opr;
	cin >> b.up2 >> b.down2;

	if (!strcmp(opr, "add")) // 입력된 연산자 확인 후 함수로 보냄
		add(a, b);
	else if (!strcmp(opr, "sub"))
		sub(a, b);
	else if (!strcmp(opr, "multi"))
		multi(a, b);
	else if (!strcmp(opr, "div"))
		div(a, b);

	int gcd = GCD(up, down);
	up /= gcd, down /= gcd;

	if (down == 1) 
		cout << up << endl; // 분모가 1이면 분자만 출력
	else  
		cout << up << "/" << down << endl; // 분자 / 분모 출력
}

void add(struct num1 a, struct num2 b) // 덧셈 함수
{
	int upper, lower; // 임시 저장용
	upper = (a.up1*b.down2) + (b.up2*a.down1);
	lower = a.down1*b.down2;

	up = upper;
	down = lower;
}

void sub(struct num1 a, struct num2 b) // 뺄셈함수
{
	int upper, lower;
	upper = (a.up1*b.down2) - (b.up2*a.down1);
	lower = a.down1*b.down2;

	up = upper;
	down = lower;
}

void multi(struct num1 a, struct num2 b) // 곱셈함수
{
	int upper, lower;
	upper = a.up1*b.up2;
	lower = a.down1*b.down2;

	up = upper;
	down = lower;
}

void div(struct num1 a, struct num2 b) // 나눗셈 함수
{
	int upper, lower;
	upper = a.up1*b.down2;
	lower = a.down1*b.up2;

	up = upper;
	down = lower;	
}

int GCD(int num1, int num2) // 분자와 분모의 최대공약수 구하기
{
	int i, temp;
	if (num1 >= num2)
		temp = num2;
	else
		temp = num1;
	for (i = temp; i>1; i--)
	{
		if (num1%i == 0 && num2%i == 0)
			break;
	}
	return i;
}
