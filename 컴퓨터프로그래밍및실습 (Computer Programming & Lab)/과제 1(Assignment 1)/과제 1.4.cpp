#include <iostream>
#include <math.h>
using namespace std;

int arr[16] = { 0 }; // ���� ���̼��� ���� �������� ����, ����� ���� �迭
void print(); // ��� ���
void sort(); // ���� �� ���

int main()
{
	int a, b, ar[4] = { 2, 3, 4, 5 }, br[4] = { 2, 3, 4, 5 }, num = 0; // ar,br�� �� ����� ���� �迭

	print();

	for (a = 0; a < 4; a++) // ����� �ֱ�
		for (b = 0; b < 4; b++)
		{
			arr[num] = pow(ar[a], br[b]);
			num++;
		}

	sort();

	cout << endl;
}

void print() // ��� �Լ�
{
	int a, b;
	for (a = 2; a < 6; a++)
	{
		for (b = 2; b < 6; b++)
		{
			cout << a << "^" << b << "=" << pow(a, b);

			if (b == 5) // a^5 �� �ڿ� , ��� ���ϰ� �ϱ�
			{
				continue;
				cout << ", ";
			}
			else
				cout << ", " << "  ";
		}
		cout << endl; // a�� ������ ���� �� �ٲ�
	}
	cout << endl;
}

void sort() // ���� �Լ�
{
	int i, j, temp, count = 0;

	for (i = 15; i >= 0; i--)     // ������ �������� ����
		for (j = 0; j < i; j++)         // ������ ������
			if (arr[j] > arr[j + 1])  // ������ ������ �� ������ �� ũ��
			{
				temp = arr[j];        // ������ �����͸� ���� �ٲ۴�.
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
			}

	for (i = 0; i < 16; i++) // ī����
	{
		if (arr[i] == arr[i + 1])
			continue;
		else
			count++;
	}
	cout << endl << "Count = " << count << endl;

	for (i = 0; i < 16; i++) // ���
	{
		if (arr[i] == arr[i + 1])
			continue;

		else
		{
			cout << arr[i];
			if (arr[i] == 3125) // ������ �� �ڿ� , ��� ���ϰ� �ϱ�
				continue;
			else
				cout << ", ";
		}
		
	}
}