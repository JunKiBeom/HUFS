#include <iostream>
using namespace std;

int num = 0; // ���ڿ� ���� ��� ����

void str(char *ary);

int main()
{
	char arr[256]; // �Է¹��� ���ڿ�
	cin.getline(arr, 256);

	str(arr);
	cout << num << endl;
}

void str(char *ary) // �����ͷ� ���ڿ� �ް� ���� ���
{
	int i;
	for (i = 0; i < 256; i++)
	{
		if (ary[i] == '\0') // \0�� null���� ���޽� ����
			break;
		else
			num++;
	}
}