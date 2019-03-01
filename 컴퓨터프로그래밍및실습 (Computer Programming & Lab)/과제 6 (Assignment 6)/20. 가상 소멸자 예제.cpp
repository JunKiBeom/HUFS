#include <iostream>
using namespace std;

class Animal // 동물 클래스
{
public:
	Animal(); // 생성자
	virtual ~Animal(); // 가상 소멸자
	virtual void speak(); // 가상 함수
};
Animal::Animal()
{
	cout << "Animal 생성자" << endl;
}
Animal::~Animal()
{
	cout << "Animal 소멸자" << endl;
}

void Animal::speak()
{
	cout << "Animal speak()" << endl;
}

class Dog :public Animal // 개 클래스, 동물 클래스 상속
{
public:
	Dog(); // 생성자
	~Dog(); // 소멸자
	void speak();
};
Dog::Dog()
{
	cout << "Dog 생성자" << endl;
}
Dog::~Dog()
{
	cout << "Dog 소멸자" << endl;
}
void Dog::speak()
{
	cout << "멍멍!" << endl;
}

int main()
{
	Animal *a1 = new Dog(); // Dog 생성
	a1->speak(); // Dog::speak() 호출

	delete a1;

}