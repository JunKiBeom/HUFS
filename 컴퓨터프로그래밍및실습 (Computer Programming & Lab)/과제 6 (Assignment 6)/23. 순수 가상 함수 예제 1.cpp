#include <iostream>
using namespace std;

class Figure // Figure Ŭ����
{
protected:
	int x, y; // x, y ��ǥ
public:
	void setOrigin(int x, int y); // x, y �� ����
	virtual void draw() = 0; // ���� ���� �Լ� ��� �� draw
};
void Figure::setOrigin(int x, int y)
{
	this->x = x;
	this->y = y;
}

class Circle :public Figure // Circle Ŭ����, Figure Ŭ���� ��� ����
{
private:
	int radius; // ������
public:
	void setRadius(int r); // ������ ����
	void draw();
};
void Circle::setRadius(int r)
{
	radius = r;
}
void Circle::draw()
{
	cout << "Circle draw" << endl;
}

int main()
{

	Figure *ps = new Circle(); // ����
	ps->draw(); // ���� ��ü�� draw() ȣ�� = Circle::draw() ȣ��
	delete ps; // �ݳ�
}