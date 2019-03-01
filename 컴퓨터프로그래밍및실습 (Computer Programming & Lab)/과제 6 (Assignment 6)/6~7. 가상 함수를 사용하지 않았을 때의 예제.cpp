#include <iostream>
using namespace std;

class Figure // Figure Ŭ����
{
protected:
	int x, y; // x, y ��ǥ
public:
	void draw(); // ���� �Լ� ��� ���� draw
	void setOrigin(int x, int y); // x, y �� ����
};
void Figure::draw()
{
	cout << "Figure Draw" << endl;
}
void Figure::setOrigin(int x, int y)
{
	this->x = x;
	this->y = y;
}

class Rectangle :public Figure // Rectangle Ŭ����, Figure Ŭ���� ��� ����
{
private:
	int width, height; // ����, ��
public:
	void setWidth(int w); // �� ����
	void setHeight(int h); // ���� ����
	void draw();
};

void Rectangle::setWidth(int w)
{
	width = w;
}
void Rectangle::setHeight(int h)
{
	height = h;
}
void Rectangle::draw()
{
	cout << "Rectangle Draw" << endl;
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
	Figure *ps = new Rectangle(); // ����
	ps->draw(); // Figure::draw(); ȣ��
	delete ps; // �ݳ�

	Figure *ps2 = new Circle(); // ����
	ps2->draw(); // Figure::draw(); ȣ��
	delete ps2; // �ݳ�
}