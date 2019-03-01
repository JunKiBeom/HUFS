#include <iostream>
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
	int num; // 학생 수
	struct student *arr = 0; // 구조체 포인터
	cin >> num;
	
	arr = new student[num]; // 학생 수 만큼 구조체 배열 크기 동적할당

	for (int i=0; i < num; i++)
	{
		int credit[2] = { 0 }; // 성적 저장 배열
		arr[i].name = new char[100]; // 학생 이름 최대 100칸으로 동적할당
		cin >> arr[i].name;
		for (int j = 0; j < 2; j++)
		{
			cin >> arr[i].math[j]; // 수학 성적 중간 기말 순으로 입력
			credit[0] += arr[i].math[j]; // 0번 배열에 수학 성적 합 저장
		}
		for (int j = 0; j < 2; j++)
		{
			cin >> arr[i].eng[j]; // 영어 성적 중간 기말 순으로 입력
			credit[1] += arr[i].eng[j]; // 1번 배열에 영어 성적 합 저장
		}

		for (int n = 0; n < 2; n++)
		{
			switch (n) // 수학 = 0, 영어 = 1 구분
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
		cout << arr[i].name << " " << arr[i].mathGrade << " " << arr[i].engGrade << endl; // 출력
		delete[] arr[i].name; // 출력했으면 반납
	}
	delete[] arr; // 실행 끝나면 반납
}