#include <iostream>
using namespace std;

class Figure // Figure 클래스
{
protected:
	int x, y; // x, y 좌표
public:
	void draw(); // 가상 함수 사용 안한 draw
	void setOrigin(int x, int y); // x, y 값 설정
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

class Rectangle :public Figure // Rectangle 클래스, Figure 클래스 상속 받음
{
private:
	int width, height; // 높이, 폭
public:
	void setWidth(int w); // 폭 설정
	void setHeight(int h); // 높이 설정
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

class Circle :public Figure // Circle 클래스, Figure 클래스 상속 받음
{
private:
	int radius; // 반지름
public:
	void setRadius(int r); // 반지름 설정
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
	Figure *ps = new Rectangle(); // 생성
	ps->draw(); // Figure::draw(); 호출
	delete ps; // 반납

	Figure *ps2 = new Circle(); // 생성
	ps2->draw(); // Figure::draw(); 호출
	delete ps2; // 반납
}
