#include <iostream>
using namespace std;

class Vector // ���� Ŭ����
{
private:
	double x, y;
public:
	Vector(double xvalue = 0.0, double yvalue = 0.0) :x(xvalue), y(yvalue){} // �⺻ �ʱ�ȭ
	void display() // ���
	{
		cout << "(" << x << "," << y << ")" << endl;
	}
	Vector operator+(Vector& v2) // ��� �Լ��� ������ �ߺ�, +������ �Լ� ����
	{
		Vector v;
		v.x = this->x + v2.x;
		v.y = this->y + v2.y;
		return v;
	}
};

int main()
{
	Vector v1(1.0, 2.0), v2(3.0, 4.0);
	Vector v3 = v1 + v2;

	v3.display();
}