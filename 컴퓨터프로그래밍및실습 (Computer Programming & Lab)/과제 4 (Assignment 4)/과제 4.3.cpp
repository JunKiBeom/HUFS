#include <iostream>
using namespace std;

void check();
int num[21781] = { 0 }; // 1 ~ 21780���� ���� �־�δ� �迭
int arr[6]; // �Է¹��� ���� ���ڸ��� ���ϱ� ���� �迭

int main()
{
	int start, end; // ���� �� ��
	cin >> start >> end;

	for (int i = 0; i < end; i++) // �ʱ�ȭ
	{
		if (start > end) // ���۰��� �� ������ Ŀ���� �ʱ�ȭ ����
			break;
		num[i] = start++; // ���۰� ~ ���� �ʱ�ȭ
	}
	
	check();

	/*for (int i = 0; i < end; i++)
		cout << num[i] << " ";*/
	/*for (int i = 0; i < 6; i++)
		cout << arr[i] << " ";*/
}
void check() // ���������� üũ �� ��� �Լ�
{
	int cnt1 = 0, cnt2 = 0, cnt3 = 0;// cnt1 100 ~ 999���� ��������,cnt2 1000 ~ 9999���� ��������, cnt3 10000 ~ 21780���� ��������

	for (int i = 0; num[i] != 0; i++)
	{
		int bcnt = 0, lcnt = 0, scnt = 0; // bcnt ������ lcnt ���Ҽ� scnt ���ϼ��� �Ǵ� ī��Ʈ

		if (num[i] > 99 && num[i] < 1000) // 100 ~ 999
		{
			arr[0] = num[i] / 100 % 100;
			arr[1] = num[i] / 10 % 10;
			arr[2] = num[i] % 10;

			for (int j = 0; j < 2; j++) // ���������� Ȯ��
			{
				if (arr[j] > arr[j + 1])
					bcnt++;
				else if (arr[j] == arr[j + 1])
					scnt++;
				else if (arr[j] < arr[j + 1])
					lcnt++;
			}
			if (bcnt < 2 && lcnt < 2 && scnt < 1)
			{
				cnt1++;
				//cout << num[i] << " ";
			}
		}
		else if (num[i] > 999 && num[i] < 10000) // 1000 ~ 9999
		{
			arr[0] = num[i] / 1000 % 10;
			arr[1] = num[i] / 100 % 10;
			arr[2] = num[i] / 10 % 10;
			arr[3] = num[i] % 10;

			for (int j = 0; j < 3; j++) // ���������� Ȯ��
			{
				if (arr[j] > arr[j + 1])
					bcnt++;
				else if (arr[j] == arr[j + 1])
					scnt++;
				else if (arr[j] < arr[j + 1])
					lcnt++;
			}
			if (bcnt <3 && lcnt <3 && scnt <2)
			{
				cnt2++;
				//cout << num[i] << " ";
			}
			if (bcnt == 0 && lcnt == 2 && scnt == 1) // �߸� ī��Ʈ �� ���ڵ� ����
				cnt2--;
			else if (bcnt == 2 && lcnt == 0 && scnt == 1)
				cnt2--;
		}
		else if (num[i] > 9999 && num[i] <= 21780) // 10000 ~ 21780
		{
			arr[0] = num[i] / 10000 % 10;
			arr[1] = num[i] / 1000 % 10;
			arr[2] = num[i] / 100 % 10;
			arr[3] = num[i] / 10 % 10;
			arr[4] = num[i] % 10;

			for (int j = 0; j < 4; j++) // ���������� Ȯ��
			{
				if (arr[j] > arr[j + 1])
					bcnt++;
				else if (arr[j] == arr[j + 1])
					scnt++;
				else if (arr[j] < arr[j + 1])
					lcnt++;
			}
			if (bcnt < 4 && lcnt < 4 && scnt < 3)
			{
				cnt3++;
				//cout << num[i] << " ";
			}
			if (bcnt == 0 && lcnt == 3 && scnt == 1)
				cnt3--;
			else if (bcnt == 3 && lcnt == 0 && scnt == 1)
				cnt3--;
			else if (bcnt == 0 && lcnt == 2 && scnt == 2)
				cnt3--;
			else if (bcnt == 2 && lcnt == 0 && scnt == 2)
				cnt3--;
		}
	}
	
	cout << cnt1 + cnt2 + cnt3 << endl;
}