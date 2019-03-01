#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <Windows.h>
#pragma warning (disable:4996)

int main()
{
	char check;
	int answer, score;
	int fscore = 0, lscore = 0, quiz = 1; // fscore 게임점수, lscore 이전게임 점수, quiz 문제 출력횟수 및 문제 번호
	clock_t start, end; // 총 걸린시간 계산
	clock_t input, output; // 입력시간 및 점수 계산

game:
	{
		fscore = 0, quiz = 1; // 다시 게임시 게임 실행을 위한 값 초기화

		printf("구구단을 외자. 답을 문제 출력 후 3초 이내에 입력하세요.\n준비하세요.\n");
		for (int i = 3; i >= 0; i--)
		{
			if (i == 0)
				printf("Start~!\n");

			else
			{
				printf("%d초전\n", i);
				Sleep(1000); // 1초간격 출력
			}
		}

		start = clock(); // 게임 실행 시작 시간
		for (quiz; quiz <= 10; quiz++)
		{
			srand((unsigned)time(NULL)); // 랜덤
			int num1 = rand() % 9 + 1;
			int num2 = rand() % 9 + 1;

			printf(" %d) %d * %d =",quiz, num1, num2);
			output = clock(); // 출력 시간
			scanf("%d", &answer);
			input = clock(); // 입력시간

			score = 3000 - (input - output); // 점수 계산

			if (score <= 0) // 3초 아웃
			{
				printf("(제한시간이 지났습니다) Score = %d\n", fscore);
			}
			else if (answer == num1*num2)
			{
				fscore += score;
				printf("(맞았습니다.) Score = %d\n", fscore);
			}
			else if (answer != num1*num2)
			{
				printf("(틀렸습니다.) Score =  %d\n", fscore);
			}
			printf("\n"); // 가독성을 위해 한 줄 띄움
		}
		end = clock(); // 게임 실행 끝 시간
	}
	if (fscore > lscore)
		printf("\a축하합니다! 최고기록입니다!\n"); // 최고 점수 달성시 경고음 출력과 축하메시지 출력

	printf("총 걸린시간은  %.lf초 이며 총점은 %d점 입니다..\n\n", (double)(end - start) / 1000, fscore);

	if (fscore>lscore)
		lscore = fscore; // 이전 점수 저장

	while (1) // 잘못입력받을시 다시 입력받기위한 장치
	{
		printf("게임을 계속 하시겠습니까? (Y/N)");
		scanf(" %c", &check);

		if (check == 'Y')
			goto game; // 게임 시작점으로 돌아감. 다시 시작

		else if (check == 'N')
		{
			printf("최고점수는 %d점 입니다..\n게임을 종료합니다.\n",lscore);
			break;
		}
	}
	return 0;
}