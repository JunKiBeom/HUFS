#include <iostream>
using namespace std;

class Complex // ���Ҽ� Ŭ����
{
private:
	int re, im; // �Ǽ�, ���
public:
	friend Complex add(Complex a1, Complex a2); // ������ �Լ� ����, �� ��ü ����
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
Complex add(Complex a1, Complex a2) // ������ �Լ� ����
{
	return Complex(a1.re + a2.re, a1.im + a2.im); // �Ǽ���, ����� ���� ��� �� �� ��ȯ
}

int main()
{
	Complex c1(4, 6), c2(5, 8);
	Complex c3 = add(c1, c2); // ���
	c3.output(); // ���
}