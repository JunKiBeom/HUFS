#include <iostream>
#include <cmath>
using namespace std;


double arr[10000] = { 0, }; // ���� ���̼��� ���� �������� ����, ����� ���� �迭
void sort(int num); // ���� �� ���

int main()
{
	int a, b;
	int num = 0;
	cin >> a >> b; // �� ���� �Է� �ޱ�

	for (int i = 2; i <= a; i++) // ����� �ֱ�
		for (int j = 2; j <= b; j++)
		{
			arr[num] = pow(i, j);
			num++;
		}

	sort(num);

	cout << endl;
	/*for (int i = 0; i < num; i++)
		cout << arr[i] << " ";*/
}

void sort(int num) // ���� �Լ�
{
	int i, j, count = 0;
	double temp;

	for (i = num - 1; i >= 0; i--)  // ������ �������� ����
		for (j = 0; j < i; j++)         // ������ ������
			if (arr[j] > arr[j + 1])  // ������ ������ �� ������ �� ũ��
			{
				temp = arr[j];        // ������ �����͸� ���� �ٲ۴�.
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
			}

	for (i = 0; i < num; i++) // ī����
	{
		if (arr[i] == arr[i + 1])
			continue;
		else
			count++;
	}
	cout << count << endl;
}