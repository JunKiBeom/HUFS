#include <iostream>
using namespace std;

int main()
{
	int num;
	int a, b;
	int i, cnt = 0;
	char alp = 'A';

	cin >> num;
	num = (num / 2.0 + 0.5); // �� �ϴ� ����� ���� ����

	if (num % 2 == 0) // num�� ¦���϶�(7+4n)
	{
		for (i = 0; i < num + 1; i++) // ������ ��� ���
		{
			for (a = num - 1; a > cnt; a--) // ���� ���
				cout << " ";
			for (b = 0; b <= cnt; b++)
			{
				if (b % 2 == 0) // ¦�� �ڸ��϶� ���
				{
					if (alp > 'Z')
						alp = 'A';
					cout << alp << " ";
					alp++;
				}
				else // Ȧ�� �ڸ��϶� ���� ���
					cout << "  ";

			}
			cout << endl;
			cnt++; // ���� ī��Ʈ ����

			if (cnt >= num) // ī��Ʈ�� ���ں��� Ŀ���� �ݺ��� ����
				break;
		}
	}
	else // num�� Ȧ���϶� (5+4n)
	{
		for (i = 0; i < num + 1; i++) // ������ ��� ���
		{
			for (a = num - 1; a > cnt; a--) // ���� ���
				cout << " ";
			for (b = 0; b <= cnt; b++)
			{
				if (b % 2 == 0) // ¦�� �ڸ��϶� ���
				{
					if (alp > 'Z')
						alp = 'A';
					cout << alp << " ";
					alp++;
				}
				else // Ȧ�� �ڸ��϶� ���� ���
					cout << "  ";
			}
			cout << endl;
			cnt++; // ���� ī��Ʈ ����

			if (cnt >= num) // ī��Ʈ�� ���ں��� Ŀ���� �ݺ��� ����
				break;
		}
	}
	int ncnt = num;
	int mcnt = num - 1;
	int dcnt = 0; // �ϴܺ� ����� ���� ���� ����

	if (num % 2 == 0) // num�� ¦���϶�(7+4n)
	{
		for (i = 0; i < num - 2; i++) // �ϴܺ� ���
		{
			int temp = i;
			if (temp / 2 > 0 && temp % 2 == 0)
				dcnt -= 4;
			for (a = 3; a > dcnt; a--)
				cout << " ";
			int run = mcnt / 2;
			while (run > 0)
			{
				if (alp > 'Z')
					alp = 'A';
				cout << alp;
				alp++;
				if (run != 1) // �� ���� ������ ���� ����� �ƴҰ��
				{
					for (a = 0; a < 3; a++)
						cout << " ";
				}
				else // �� ���� ������ ���� ����� ���
				{
					for (a = 0; a < 3; a++)
						cout << " ";
				}
				run--;
			}
			cout << endl;
			mcnt--;
			dcnt++;
		}
	}
	else // num�� Ȧ���϶� (5+4n)
	{
		for (i = 0; i < num - 1; i++) // �ϴܺ� ���
		{
			int temp = i;
			if (temp / 2 > 0 && temp % 2 == 0)
				dcnt -= 4;
			for (a = 3; a > dcnt; a--)
				cout << " ";
			int run = ncnt / 2;
			while (run > 0)
			{
				if (alp > 'Z')
					alp = 'A';
				cout << alp;
				alp++;
				if (run != 1) // �� ���� ������ ���� ����� �ƴҰ��
				{
					for (a = 0; a < 3; a++)
						cout << " ";
				}
				else // �� ���� ������ ���� ����� ���
				{
					if (num == 5) // 9 �Է½� �ϴܺ� �ڿ� ���� 1�� 
						for (a = 0; a < 1; a++)
							cout << " ";
					else // �ٸ��� �ϰ�� ���� 3��
						for (a = 0; a < 3; a++)
							cout << " ";
				}
				run--;
			}
			cout << endl;
			ncnt--;
			dcnt++;
		}
	}
}