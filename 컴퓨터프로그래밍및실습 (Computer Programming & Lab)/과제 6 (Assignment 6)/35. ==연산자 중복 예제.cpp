#include <iostream>
using namespace std;

class Vector // 벡터 클래스
{
private:
	double x, y;
public:
	Vector(double xvalue = 0.0, double yvalue = 0.0) :x(xvalue), y(yvalue){} // 기본 초기화
	void display() // 출력
	{
		cout << "(" << x << "," << y << ")" << endl;
	}
	friend bool operator==(const Vector& v1, const Vector& v2);
	friend bool operator!=(const Vector& v1, const Vector& v2);
};
bool operator==(const Vector& v1, const Vector& v2) // ==연산자 함수 정의, 전역 함수로 구현
{
	return v1.x == v2.x&&v1.y == v2.y; // 같으면 1 반환
}
bool operator!=(const Vector& v1, const Vector& v2)
{
	return !(v1 == v2); // 다르면 1 반환
}


int main()
{
	Vector v1(1, 2), v2(1, 2);
	Vector v3(5, 6), v4(7, 8);

	if (v1 == v2)
		cout << "true" << endl;
	if (v3 != v4)
		cout << "false" << endl;
}