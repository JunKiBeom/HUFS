#include <iostream>
using namespace std;

class Animal // 동물 클래스
{
public:
	virtual void speak(); // 가상 함수
};
void Animal::speak()
{
	cout << "Animal speak()" << endl;
}

class Dog :public Animal // 개 클래스, 동물 클래스 상속
{
public:
	void speak();
};
void Dog::speak()
{
	cout << "멍멍!" << endl;
}

class Cat :public Animal // 고양이 클래스, 동물 클래스 상속
{
public:
	void speak();
};
void Cat::speak()
{
	cout << "야옹~" << endl;
}

int main()
{
	Dog d; // 개 클래스 d생성
	Animal &a1 = d; // 동물 클래스 a1 = d
	a1.speak(); // a1.speak() 호출 = d.speak()호출

	Cat c; // 고양이 클래스 c생성
	Animal &a2 = c; // 동물 클래스 a2 = c
	a2.speak(); // a2.speak() 호출 = c.speak()호출
}
