#include <iostream>
using namespace std;

int main()
{
	int i, count = 0, calc = 0; // count�� ����� �Է��� �޾Ҵ��� Ȯ���ϴ� Ƚ��, calc�� �Է¹��� �迭�� �� ����
	int *arr = 0, *temp = 0; // �����Ҵ��� ���� ������
	int stop = -2147483648LL; // -2147483648 �Է½� ���α׷� ����, long long������ ����ȯ
	for (i = 1;; i++)
	{
		arr = new int[i]; // i�� �ݺ���ŭ ũ�� �����Ҵ�

		if (i > 1) // 1���� Ŭ ��� temp���� arr�� �ű�
			for (int j = 0; j < i - 1; j++)
				arr[j] = temp[j];

		delete[] temp; // ��� �� �ݳ�
		temp = new int[i]; // i�� �ݺ���ŭ ũ�� �����Ҵ�

		if (i > 1) // arr�� ���� temp�� ����
			for (int j = 0; j < i - 1; j++)
				temp[j] = arr[j];

		cin >> arr[i - 1]; // arr �Է¹���

		if (arr[i - 1] == stop) // arr�� ���� -2147483648�� ��� �Է� ���� �� ��� �ջ�, for�� Ż��
		{
			for (int i = 0; i < count; i++)
				calc += temp[i];
			break;
		}

		else  // �׷��� ������ count +1, temp�� arr�� ����
		{
			count++;
			temp[i - 1] = arr[i - 1];
			delete[] arr; // ��� �� �ݳ�
		}
	}
	cout << calc << endl; // �ջ��� �� ���
}