#include <iostream>
using namespace std;

int main()
{
	char arr[10000]; // ���ڿ� �Է� ���� �迭
	int Bcnt = 0, Lcnt = 0, Ncnt = 0, Scnt = 0; // �빮��, �ҹ���, ���鹮��, Ư������ ī��Ʈ ����

	cin.getline(arr, 10000);

	for (int i = 0; arr[i] != 0; i++) // NULL���� ���� for�� �ݺ�
	{
		if ((arr[i] >= '!') && (arr[i] <= '@')) // Ư�������ϰ��
			Scnt++;
		else if ((arr[i] >= '[') && (arr[i] <= '`')) // Ư�������ϰ��
			Scnt++;
		else if ((arr[i] >= '{') && (arr[i] <= '~')) // Ư�������ϰ��
			Scnt++;
		else if ((arr[i] >= 'A') && (arr[i] <= 'Z')) // �빮���ϰ��
			Bcnt++;
		else if ((arr[i] >= 'a') && (arr[i] <= 'z')) // �ҹ����ϰ��
			Lcnt++;
		else if (arr[i] == ' ') // �����ϰ��
			Ncnt++;
	}
	cout << Bcnt << " " << Lcnt << " " << Ncnt << " " << Scnt << endl;
}