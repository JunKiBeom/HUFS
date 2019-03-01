#include <iostream>
#include <cstring> // strcmp����� ���� ���
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
	int count = 0; // �� �� ���Ҵ��� ī��Ʈ
	struct student *arr = 0; // ����ü ������
	struct student *temp = 0; // �ӽ� ���� ����

	for (int i = 1;; i++)
	{
		arr = new student[i]; // i�� ũ�⸸ŭ ���� �Ҵ�

		if (i > 1) // arr�� temp�� �� �ֱ�
			for (int j = 0; j < i - 1; j++)
			{
				arr[j].name = temp[j].name;
				arr[j].math[0] = temp[j].math[0];
				arr[j].math[1] = temp[j].math[1];
				arr[j].eng[0] = temp[j].eng[0];
				arr[j].eng[1] = temp[j].eng[1];
				arr[j].mathGrade = temp[j].mathGrade;
				arr[j].engGrade = temp[j].engGrade;
			}

		temp = new student[i]; // i�� ũ�⸸ŭ ���� �Ҵ�

		if (i > 1) // temp�� arr�� �ֱ�
			for (int j = 0; j < i - 1; j++)
			{
				temp[j].name = arr[j].name;
				temp[j].math[0] = arr[j].math[0];
				temp[j].math[1] = arr[j].math[1];
				temp[j].eng[0] = arr[j].eng[0];
				temp[j].eng[1] = arr[j].eng[1];
				temp[j].mathGrade = arr[j].mathGrade;
				temp[j].engGrade = arr[j].engGrade;
			}

		int credit[2] = { 0 }; // ���� ���� �迭
		arr[i - 1].name = new char[100];// �л� �̸� �ִ� 100ĭ���� �����Ҵ�
		cin >> arr[i - 1].name;

		if (!strcmp(arr[i - 1].name, "null")) // null�� �ԷµǸ� for�� ����
			break;

		for (int j = 0; j < 2; j++)
		{
			cin >> arr[i - 1].math[j];// ���� ���� �߰� �⸻ ������ �Է�
			credit[0] += arr[i - 1].math[j]; // 0�� �迭�� ���� ���� �� ����
		}
		for (int j = 0; j < 2; j++)
		{
			cin >> arr[i - 1].eng[j]; // ���� ���� �߰� �⸻ ������ �Է�
			credit[1] += arr[i - 1].eng[j]; // 1�� �迭�� ���� ���� �� ����
		}

		// temp�� arr�� �ֱ�
		temp[i - 1].name = arr[i - 1].name;
		temp[i - 1].math[0] = arr[i - 1].math[0];
		temp[i - 1].math[1] = arr[i - 1].math[1];
		temp[i - 1].eng[0] = arr[i - 1].eng[0];
		temp[i - 1].eng[1] = arr[i - 1].eng[1];
		temp[i - 1].mathGrade = arr[i - 1].mathGrade;
		temp[i - 1].engGrade = arr[i - 1].engGrade;

		for (int n = 0; n < 2; n++)
		{
			switch (n) // ���� = 0, ���� = 1 ����
			{
			case 0:
				if (credit[0] >= 180)
				{
					temp[i - 1].mathGrade = 'A';
					break;
				}
				else if ((credit[0] <= 179) && (credit[0] >= 160))
				{
					temp[i - 1].mathGrade = 'B';
					break;
				}
				else if ((credit[0] <= 159) && (credit[0] >= 130))
				{
					temp[i - 1].mathGrade = 'C';
					break;
				}
				else if ((credit[0] <= 129) && (credit[0] >= 100))
				{
					temp[i - 1].mathGrade = 'D';
					break;
				}
				else
				{
					temp[i - 1].mathGrade = 'F';
					break;
				}

			case 1:
				if (credit[1] >= 180)
				{
					temp[i - 1].engGrade = 'A';
					break;
				}
				else if ((credit[1] <= 179) && (credit[1] >= 160))
				{
					temp[i - 1].engGrade = 'B';
					break;
				}
				else if ((credit[1] <= 159) && (credit[1] >= 130))
				{
					temp[i - 1].engGrade = 'C';
					break;
				}
				else if ((credit[1] <= 129) && (credit[1] >= 100))
				{
					temp[i - 1].engGrade = 'D';
					break;
				}
				else
				{
					temp[i - 1].engGrade = 'F';
					break;
				}
			}

		}
		count++; // ī��Ʈ ����
	}
	for (int i = 0; i < count; i++) // ī��Ʈ ��ŭ�� for�� �ݺ�
	{
		cout << arr[i].name << " " << temp[i].mathGrade << " " << temp[i].engGrade << endl; // ���
		delete[] arr[i].name; // ��������� �ݳ�
	}
	delete[] arr; // ���� ������ �ݳ�
	delete[] temp; // ���� ������ �ݳ�
}