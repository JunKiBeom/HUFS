#include <iostream>
using namespace std;

int main()
{
	int arr[10] = { 0 };
	int sum = 0, avg = 0;
	for (int loop = 0; loop < 10; loop++)
	{
		cin >> arr[loop];
		if (loop == 9)
		{
			for (int num = 0; num < 10; num++)
			{
				sum += arr[num];
				avg += arr[num];
			}
			avg /= 10;
		}
	}
	cout << "�迭�� �� = " << sum << endl;
	cout << "�迭�� ��� = " << avg << endl;

	return 0;
}