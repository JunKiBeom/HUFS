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
	score = 0, plus = +10, combo = 0; //�ʱ�ȭ

	printf("ȭ�鿡 X�� ǥ�õǸ� 1��, O�� ǥ�õǸ� 2�� ��������.\n");
	Sleep(500);
	printf("������ �����մϴ�. �غ� �Ǿ����� 1�� ��������.");
	scanf("%d", &start_num);

	if (start_num == 1)
		printf("\n");
	else
		goto intro; //���Է�

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
			printf("(�����ð� : %.3f�� . ����� ���� : %d) �Է���?", remain_t, score);

		else
		printf("(�����ð� : %.3f�� . ����� ���� : %d (+%d)) �Է���?",remain_t, score, plus+combo-1);
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
		printf("�����մϴ�! �ְ����Դϴ�!\n");

	printf("������ %d�� �Դϴ�\n\n", score);

	if (score>lscore)
		lscore = score; //���� ���� ����

	while (1)
	{
		printf("������ ��� �Ͻðڽ��ϱ�? (Y/N)");
		scanf(" %c", &check);

		if (check == 'Y')
			goto intro;
		else if (check == 'N')
		{
			printf("�ְ������� %d�� �Դϴ�..\n������ �����մϴ�.\n", lscore);
			break;
		}
	}
	return 0;


}