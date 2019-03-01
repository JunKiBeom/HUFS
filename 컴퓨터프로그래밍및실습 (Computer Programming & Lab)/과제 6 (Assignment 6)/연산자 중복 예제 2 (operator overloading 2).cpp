#include <iostream>
using namespace std;

class Vector // 벡터 클래스
{
	friend Vector operator+(const Vector& v1, const Vector& v2); // 전역 함수로 연산자 함수 선언
private:
	double x, y;
public:
	Vector(double xvalue = 0.0, double yvalue = 0.0) :x(xvalue), y(yvalue){} // 기본 초기화
	void display() // 출력
	{
		cout << "(" << x << "," << y << ")" << endl;
	}
};
Vector operator+(const Vector& v1, const Vector& v2) // 전역 함수로 +연산자 함수 구현
{
	Vector v(0.0, 0.0);
	v.x = v1.x + v2.x;
	v.y = v1.y + v2.y;
	return v;
}

int main()
{
	Vector v1(1.0, 2.0), v2(3.0, 4.0);
	Vector v3 = v1 + v2;

	v3.display();
}
