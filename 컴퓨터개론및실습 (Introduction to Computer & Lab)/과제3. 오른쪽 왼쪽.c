#include <stdio.h>
#include <stdlib.h>
#include <Windows.h>
#include <time.h>
#pragma warning (disable:4996)

int main()
{
	char check;
	int start_num, ANSWER, answer;
	int plus = 10, score = 0,lscore = 0, combo=0, game_count=0, fever_count=0;
	int fcount = 0;
	double remain_t;

	clock_t start, end;
	clock_t fever_s, superfever_s, ultrafever_s;
	clock_t fever_e=0, superfever_e, ultrafever_e;

intro:
	score = 0, plus = +10, combo = 0; //초기화

	printf("화면에 X가 표시되면 1을, O가 표시되면 2를 누르세요.\n");
	Sleep(500);
	printf("게임을 시작합니다. 준비가 되었으면 1을 누르세요.");
	scanf("%d", &start_num);

	if (start_num == 1)
		printf("\n");
	else
		goto intro; //재입력

	start = clock();
	for (int num=1;; num++)

	nomal:
	{
		srand(time(NULL));
		int game = rand();

		if (game%2==0)
		{
			printf("\n  OO\nO    O\nO    O\nO    O\n  OO\n");
			ANSWER = 2;
		}
		else
		{
			printf("\nX   X\n X X\n  X\n X X\nX   X\n");
			ANSWER = 1;
		}
		end = clock();

		remain_t = (30000.0 - (end - start))/1000.0;

		if (game_count == 0)
			printf("(남은시간 : %.3f초 . 당신의 점수 : %d) 입력은?", remain_t, score);

		else
		printf("(남은시간 : %.3f초 . 당신의 점수 : %d (+%d)) 입력은?",remain_t, score, plus+combo-1);
		scanf(" %d", &answer);

			if (ANSWER == answer)
			{
				game_count = 1;
				score += plus+combo;
				combo++;
			}
			else if (ANSWER != answer)
			{
				game_count = 0;
				plus = 10;
				combo = 0;
			}



			if (remain_t <= 0)
			{
				plus = 0;
				score += plus;
				break;
			}
	}

	if (score > lscore)
		printf("축하합니다! 최고기록입니다!\n");

	printf("점수는 %d점 입니다\n\n", score);

	if (score>lscore)
		lscore = score; //이전 점수 저장

	while (1)
	{
		printf("게임을 계속 하시겠습니까? (Y/N)");
		scanf(" %c", &check);

		if (check == 'Y')
			goto intro;
		else if (check == 'N')
		{
			printf("최고점수는 %d점 입니다..\n게임을 종료합니다.\n", lscore);
			break;
		}
	}
	return 0;


}