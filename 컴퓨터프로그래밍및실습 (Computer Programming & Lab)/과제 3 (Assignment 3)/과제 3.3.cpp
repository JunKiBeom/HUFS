#include <iostream>
using namespace std;

struct student // �л� ����ü
{
	char*name;
	int math[2];
	char mathGrade;
	int eng[2];
	char engGrade;
};

int  main()
{
	int num; // �л� ��
	struct student *arr = 0; // ����ü ������
	cin >> num;
	
	arr = new student[num]; // �л� �� ��ŭ ����ü �迭 ũ�� �����Ҵ�

	for (int i=0; i < num; i++)
	{
		int credit[2] = { 0 }; // ���� ���� �迭
		arr[i].name = new char[100]; // �л� �̸� �ִ� 100ĭ���� �����Ҵ�
		cin >> arr[i].name;
		for (int j = 0; j < 2; j++)
		{
			cin >> arr[i].math[j]; // ���� ���� �߰� �⸻ ������ �Է�
			credit[0] += arr[i].math[j]; // 0�� �迭�� ���� ���� �� ����
		}
		for (int j = 0; j < 2; j++)
		{
			cin >> arr[i].eng[j]; // ���� ���� �߰� �⸻ ������ �Է�
			credit[1] += arr[i].eng[j]; // 1�� �迭�� ���� ���� �� ����
		}

		for (int n = 0; n < 2; n++)
		{
			switch (n) // ���� = 0, ���� = 1 ����
			{
			case 0:
				if (credit[0] >= 180)
				{
					arr[i].mathGrade = 'A';
					break;
				}
				else if ((credit[0] <= 179) && (credit[0] >= 160))
				{
					arr[i].mathGrade = 'B';
					break;
				}
				else if ((credit[0] <= 159) && (credit[0] >= 130))
				{
					arr[i].mathGrade = 'C';
					break;
				}
				else if ((credit[0] <= 129) && (credit[0] >= 100))
				{
					arr[i].mathGrade = 'D';
					break;
				}
				else
				{
					arr[i].mathGrade = 'F';
					break;
				}

			case 1:
				if (credit[1] >= 180)
				{
					arr[i].engGrade = 'A';
					break;
				}
				else if ((credit[1] <= 179) && (credit[1] >= 160))
				{
					arr[i].engGrade = 'B';
					break;
				}
				else if ((credit[1] <= 159) && (credit[1] >= 130))
				{
					arr[i].engGrade = 'C';
					break;
				}
				else if ((credit[1] <= 129) && (credit[1] >= 100))
				{
					arr[i].engGrade = 'D';
					break;
				}
				else
				{
					arr[i].engGrade = 'F';
					break;
				}
			}
			
		}
	}
	for (int i = 0; i < num; i++)
	{
		cout << arr[i].name << " " << arr[i].mathGrade << " " << arr[i].engGrade << endl; // ���
		delete[] arr[i].name; // ��������� �ݳ�
	}
	delete[] arr; // ���� ������ �ݳ�
}