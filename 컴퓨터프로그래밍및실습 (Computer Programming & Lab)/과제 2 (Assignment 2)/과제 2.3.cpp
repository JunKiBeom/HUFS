#include <iostream>
using namespace std;

void splitString(char *str, char delim);

int main()
{
	char str[256]; // �Է¹��� ���ڿ�
	cin.getline(str, 256);

	splitString(str, ' ');
	cout << endl;
}

void splitString(char *ary, char delim) // �����ͷ� ���ڿ� �ް� ����� ���� �� ���
{
	int i;
	for (i = 0; i < 256; i++)
	{
		if (ary[i] == '\0') // \0�� null���� ���޽� ����
			break;
		else if (ary[i] == delim) // ���ǰ� ���� ��� �����ٷ� �ٹٲ�
			cout << endl;
		else
			cout << ary[i];
	}
}