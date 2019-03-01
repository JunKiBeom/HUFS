#include <iostream>
using namespace std;

class Animal // ���� Ŭ����
{
public:
	Animal(); // ������
	virtual ~Animal(); // ���� �Ҹ���
	virtual void speak(); // ���� �Լ�
};
Animal::Animal()
{
	cout << "Animal ������" << endl;
}
Animal::~Animal()
{
	cout << "Animal �Ҹ���" << endl;
}

void Animal::speak()
{
	cout << "Animal speak()" << endl;
}

class Dog :public Animal // �� Ŭ����, ���� Ŭ���� ���
{
public:
	Dog(); // ������
	~Dog(); // �Ҹ���
	void speak();
};
Dog::Dog()
{
	cout << "Dog ������" << endl;
}
Dog::~Dog()
{
	cout << "Dog �Ҹ���" << endl;
}
void Dog::speak()
{
	cout << "�۸�!" << endl;
}

int main()
{
	Animal *a1 = new Dog(); // Dog ����
	a1->speak(); // Dog::speak() ȣ��

	delete a1;

}