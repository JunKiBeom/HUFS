#include <iostream>
using namespace std;

class Animal // ���� Ŭ����
{
public:
	virtual void speak(); // ���� �Լ�
};
void Animal::speak()
{
	cout << "Animal speak()" << endl;
}

class Dog :public Animal // �� Ŭ����, ���� Ŭ���� ���
{
public:
	void speak();
};
void Dog::speak()
{
	cout << "�۸�!" << endl;
}

class Cat :public Animal // ����� Ŭ����, ���� Ŭ���� ���
{
public:
	void speak();
};
void Cat::speak()
{
	cout << "�߿�~" << endl;
}

int main()
{
	Dog d; // �� Ŭ���� d����
	Animal &a1 = d; // ���� Ŭ���� a1 = d
	a1.speak(); // a1.speak() ȣ�� = d.speak()ȣ��

	Cat c; // ����� Ŭ���� c����
	Animal &a2 = c; // ���� Ŭ���� a2 = c
	a2.speak(); // a2.speak() ȣ�� = c.speak()ȣ��
}
