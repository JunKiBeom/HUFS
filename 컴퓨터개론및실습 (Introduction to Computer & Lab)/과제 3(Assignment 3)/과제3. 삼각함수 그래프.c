#include <stdio.h>
#include <math.h> // sin cos 함수 쓰기위해 사용

#define PI 3.1415926535897932384626433832795028841971 // 그래프의 정밀도를 높이기 위함

void graph(void) // sin값과 그래프를 출력하는 함수 
{
	double sinx, cosx; // sin_degree 값을 받을 변수
	int degree, line;
	
	for (degree = 0; degree <= 360; degree += 9)
	{
		for (line = 0; line < 50; line++) // 축 출력
			printf(" ");
		printf("|\n");

		sinx = sin((degree*(PI / 180))); // sin에 라디안값 넣어줌
		for (line = -50; line < sinx * 50; line++) // sin값 만큼 띄워줌
			printf(" ");
		printf("*\n"); // 그래프 찍고 줄바꿈

		cosx = cos((degree*(PI / 180))); // cos에 라디안값 넣어줌
		for (line = -50; line < cosx * 50; line++) // cos값 만큼 띄워줌
			printf(" ");
		printf("+\n"); // 그래프 찍고 줄바꿈
	}

}

int main(void)
{
	graph();
	return 0;
}