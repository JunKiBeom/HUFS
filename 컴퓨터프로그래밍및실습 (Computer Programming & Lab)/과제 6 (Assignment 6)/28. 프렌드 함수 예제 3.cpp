#include <iostream>
using namespace std;

class Complex // 복소수 클래스
{
private:
	int re, im; // 실수, 허수
public:
	friend Complex add(Complex a1, Complex a2); // 프렌드 함수 선언, 두 객체 선언
	Complex();
	Complex(double r);
	Complex(double r, double i);
	void output();
};
Complex::Complex()
{
	re = 0;
	im = 0;
}
Complex::Complex(double r)
{
	re = r;
	im = 0;
}
Complex::Complex(double r, double i)
{
	re = r;
	im = i;
}
void Complex::output()
{
	cout << re << " + " << im << "i" << endl;
}
Complex add(Complex a1, Complex a2) // 프렌드 함수 정의
{
	return Complex(a1.re + a2.re, a1.im + a2.im); // 실수부, 허수부 따로 계산 후 값 반환
}

int main()
{
	Complex c1(4, 6), c2(5, 8);
	Complex c3 = add(c1, c2); // 계산
	c3.output(); // 출력
}