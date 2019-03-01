#include <iostream>
#include <cstring> // strcmp사용을 위한 헤더
using namespace std;

struct student // 학생 구조체
{
	char*name;
	int math[2];
	char mathGrade;
	int eng[2];
	char engGrade;
};

int  main()
{
	int count = 0; // 몇 번 돌았는지 카운트
	struct student *arr = 0; // 구조체 포인터
	struct student *temp = 0; // 임시 저장 공간

	for (int i = 1;; i++)
	{
		arr = new student[i]; // i의 크기만큼 동적 할당

		if (i > 1) // arr에 temp의 값 넣기
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

		temp = new student[i]; // i의 크기만큼 동적 할당

		if (i > 1) // temp에 arr값 넣기
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

		int credit[2] = { 0 }; // 성적 저장 배열
		arr[i - 1].name = new char[100];// 학생 이름 최대 100칸으로 동적할당
		cin >> arr[i - 1].name;

		if (!strcmp(arr[i - 1].name, "null")) // null이 입력되면 for문 종료
			break;

		for (int j = 0; j < 2; j++)
		{
			cin >> arr[i - 1].math[j];// 수학 성적 중간 기말 순으로 입력
			credit[0] += arr[i - 1].math[j]; // 0번 배열에 수학 성적 합 저장
		}
		for (int j = 0; j < 2; j++)
		{
			cin >> arr[i - 1].eng[j]; // 영어 성적 중간 기말 순으로 입력
			credit[1] += arr[i - 1].eng[j]; // 1번 배열에 영어 성적 합 저장
		}

		// temp에 arr값 넣기
		temp[i - 1].name = arr[i - 1].name;
		temp[i - 1].math[0] = arr[i - 1].math[0];
		temp[i - 1].math[1] = arr[i - 1].math[1];
		temp[i - 1].eng[0] = arr[i - 1].eng[0];
		temp[i - 1].eng[1] = arr[i - 1].eng[1];
		temp[i - 1].mathGrade = arr[i - 1].mathGrade;
		temp[i - 1].engGrade = arr[i - 1].engGrade;

		for (int n = 0; n < 2; n++)
		{
			switch (n) // 수학 = 0, 영어 = 1 구분
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
		count++; // 카운트 증가
	}
	for (int i = 0; i < count; i++) // 카운트 만큼만 for문 반복
	{
		cout << arr[i].name << " " << temp[i].mathGrade << " " << temp[i].engGrade << endl; // 출력
		delete[] arr[i].name; // 출력했으면 반납
	}
	delete[] arr; // 실행 끝나면 반납
	delete[] temp; // 실행 끝나면 반납
}
