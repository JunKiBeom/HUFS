#include <iostream>
using namespace std;

class Figure // Figure 클래스
{
protected:
	int x, y; // x, y 좌표
public:
	void setOrigin(int x, int y); // x, y 값 설정
	virtual void draw() = 0; // 순수 가상 함수 사용 한 draw
};
void Figure::setOrigin(int x, int y)
{
	this->x = x;
	this->y = y;
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

	Figure *ps = new Circle(); // 생성
	ps->draw(); // 실제 객체의 draw() 호출 = Circle::draw() 호출
	delete ps; // 반납
}