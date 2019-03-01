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
	friend bool operator==(const Vector& v1, const Vector& v2);
	friend bool operator!=(const Vector& v1, const Vector& v2);
};
bool operator==(const Vector& v1, const Vector& v2) // ==������ �Լ� ����, ���� �Լ��� ����
{
	return v1.x == v2.x&&v1.y == v2.y; // ������ 1 ��ȯ
}
bool operator!=(const Vector& v1, const Vector& v2)
{
	return !(v1 == v2); // �ٸ��� 1 ��ȯ
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