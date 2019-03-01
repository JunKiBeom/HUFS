#include <iostream>
using namespace std;

class Vector // 벡터 클래스
{
	friend Vector operator*(Vector& v, double alpha); // 전역 함수로 연산자 함수 선언
	friend Vector operator*(double alpha, Vector& v); 
private:
	double x, y;
public:
	Vector(double xvalue = 0.0, double yvalue = 0.0) :x(xvalue), y(yvalue){} // 기본 초기화
	void display() // 출력
	{
		cout << "(" << x << "," << y << ")" << endl;
	}
};
Vector operator*(Vector& v, double alpha) // *연산자 함수 정의
{
	return Vector(alpha*v.x, alpha*v.y);
}
Vector operator*(double alpha, Vector& v)
{
	return Vector(alpha*v.x, alpha*v.y);
}

int main()
{
	Vector v(1.0, 1.0);
	Vector w = v*2.0;
	Vector z = 2.0*v;

	w.display();
	z.display();
}