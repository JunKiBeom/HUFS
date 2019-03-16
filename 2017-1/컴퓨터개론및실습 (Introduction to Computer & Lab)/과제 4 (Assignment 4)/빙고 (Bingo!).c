#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <Windows.h>
#pragma warning (disable:4996)
void checkboard();
void checkbingo();
void endbingo();
void cominput();

int userbingo[25], combingo[25], usersave[25] = { 0 }, comsave[25] = { 0 }; // 사용자 빙고, 컴퓨터 빙고, 숫자 저장
int index1 = 0, index2 = 0; // for문 변수
int usernum = 0, comnum = 0; // usernum = 사용자의 입력, comnum = 컴퓨터가 부르는 숫자
int usercount = 0, comcount = 0; // 빙고 카운트
int usersum[12] = { 0 }, comsum[12] = { 0 }; // 빙고갯수 확인
int userInput[25] = { 0 }, comInput[25] = { 0 }; // 빙고카운트를 위해 계산되는 배열
int user = 0, com = 0; // for문 동작
int game = 1, num=1, loop=0; // while문 동작 game
int check[25] = { 0 }; // 입력 중복 확인

int main()
{
	srand((unsigned int)time(NULL));
	int count = rand(); // 번갈아 가면서 입력을 받기 위한 count, 누가 시작인지 랜덤

	checkboard();

	while (game)
	{
		system("cls");
		printf("  < Your Bingo > \n"); // 사용자 빙고판 출력
		printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 1, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 2);

		for (index1 = 0; index1 < 25; index1++)
		{
			if (userbingo[index1] == usernum || userbingo[index1] == comnum)
			{
				printf("%c (%2d) ", 5, userbingo[index1]);
				usersave[index1] = userbingo[index1];
			}
			else if (userbingo[index1] == usersave[index1])
				printf("%c (%2d) ", 5, usersave[index1]);

			else
				printf("%c  %2d  ", 5, userbingo[index1]);

			if (index1 > 0 && index1 % 5 == 4)
			{
				printf("%c\n", 5);
				printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 25, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 23);
			}
		}
		printf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 3, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 4);

		printf("\n\n");
		printf(" < Computer Bingo > \n"); // 컴퓨터 빙고판 출력
		printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 1, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 2);

		for (index1 = 0; index1 < 25; index1++)
		{
			if (combingo[index1] == usernum || combingo[index1] == comnum)
			{
				printf("%c (%2d) ", 5, combingo[index1]);
				comsave[index1] = combingo[index1];
			}
			else if (combingo[index1] == comsave[index1])
				printf("%c (%2d) ", 5, comsave[index1]);

			else
				printf("%c  %2c  ", 5, '*');

			if (index1 > 0 && index1 % 5 == 4)
			{
				printf("%c\n", 5);
				printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 25, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 23);
			}
		}
		printf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 3, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 4);

		printf("\n");

		checkbingo();

		if (count % 2 == 0) // 번갈아서 입력
		{
			while (1)
			{
				printf("Input Number : ");
				scanf("%d", &usernum);
				if (usernum < 1 || usernum>25)
					printf("Input 1~25\n");
				else count++;
				break;
			}
		}
		else if (count % 2 == 1)
		{
			cominput();
			count++;
		}
		Sleep(500);
	}
}

void checkboard() // 빙고 보드판 중복 체크
{
	srand((unsigned int)time(NULL));

	for (index1 = 0; index1 < 25; index1++)
	{
		userbingo[index1] = rand() % 25 + 1;
		combingo[index1] = rand() % 25 + 1;

		for (index2 = 0; index2 < index1; index2++)
		{
			if (userbingo[index1] == userbingo[index2])
			{
				index1--;
				break;
			}
			else if (combingo[index1] == combingo[index2])
			{
				index1--;
				break;
			}
		}
	}
}

void cominput() // 입력 중복 체크
{
	for (index1 = 0; index1 < 25; index1++) // 컴퓨터 중복
	{
		while (num)
		{
			check[index1] = rand() % 25 + 1;
			int confirm = 0;
			for (index2 = 0; index2 < index1; index2++)
			{
				if (check[index2] == check[index1])
				{
					confirm = 1;
					break;
				}
			}
			if (!confirm)
				break;
		}
	}
	num = 0;

	for (index1 = 0; index1 < 25; index1++)
	{
		for (index2 = 0; index2 < 25; index2++)
			if (check[index1] == (usersave[index2]))
			{
				check[index1] = 0;
				break;
			}
	}

	while (loop<25) // 배열 값 받기
	{
		int *ptr = &check[loop];
		if (*ptr == 0)
			loop++;
		else
		{
			comnum = *ptr;
			loop++;
			break;
		}
	}
	printf("Computer Number : %d\n", comnum);
}

void checkbingo() // 빙고여부 체크
{
	// 유저 빙고 카운트
	for (user; user < 25; user++)
	{
		if (user >= 25)
			continue;
		userInput[user] = userbingo[user];
	}
	for (index1 = 0; index1 < 25; index1++)
	{
		for (index2 = 0; index2 < 25; index2++)
			if ((userInput[index1] == (usersave[index2])) || (userInput[index1] == (comsave[index2])))
			{
				userInput[index1] = 0;
				break;
			}
	}
	usercount = 0;
	// 가로
	usersum[0] = userInput[0] + userInput[1] + userInput[2] + userInput[3] + userInput[4];
	usersum[1] = userInput[5] + userInput[6] + userInput[7] + userInput[8] + userInput[9];
	usersum[2] = userInput[10] + userInput[11] + userInput[12] + userInput[13] + userInput[14];
	usersum[3] = userInput[15] + userInput[16] + userInput[17] + userInput[18] + userInput[29];
	usersum[4] = userInput[20] + userInput[21] + userInput[22] + userInput[23] + userInput[24];
	// 세로
	usersum[5] = userInput[0] + userInput[5] + userInput[10] + userInput[15] + userInput[20];
	usersum[6] = userInput[1] + userInput[6] + userInput[11] + userInput[16] + userInput[21];
	usersum[7] = userInput[2] + userInput[7] + userInput[12] + userInput[17] + userInput[22];
	usersum[8] = userInput[3] + userInput[8] + userInput[13] + userInput[18] + userInput[23];
	usersum[9] = userInput[4] + userInput[9] + userInput[14] + userInput[19] + userInput[24];
	// 대각선
	usersum[10] = userInput[0] + userInput[6] + userInput[12] + userInput[18] + userInput[24];
	usersum[11] = userInput[4] + userInput[8] + userInput[12] + userInput[16] + userInput[20];

	for (index1 = 0; index1 < 12; index1++)
		if (usersum[index1] == 0) usercount++;

	// 컴퓨터 빙고 카운트
	for (com; com < 25; com++)
	{
		if (com >= 25)
			continue;
		comInput[com] = combingo[com];
	}
	for (index1 = 0; index1 < 25; index1++)
	{
		for (index2 = 0; index2 < 25; index2++)
			if ((comInput[index1] == (usersave[index2])) || (comInput[index1] == (comsave[index2])))
			{
				comInput[index1] = 0;
				break;
			}
	}
	comcount = 0;
	// 가로
	comsum[0] = comInput[0] + comInput[1] + comInput[2] + comInput[3] + comInput[4];
	comsum[1] = comInput[5] + comInput[6] + comInput[7] + comInput[8] + comInput[9];
	comsum[2] = comInput[10] + comInput[11] + comInput[12] + comInput[13] + comInput[14];
	comsum[3] = comInput[15] + comInput[16] + comInput[17] + comInput[18] + comInput[19];
	comsum[4] = comInput[20] + comInput[21] + comInput[22] + comInput[23] + comInput[24];
	// 세로
	comsum[5] = comInput[0] + comInput[5] + comInput[10] + comInput[15] + comInput[20];
	comsum[6] = comInput[1] + comInput[6] + comInput[11] + comInput[16] + comInput[21];
	comsum[7] = comInput[2] + comInput[7] + comInput[12] + comInput[17] + comInput[22];
	comsum[8] = comInput[3] + comInput[8] + comInput[13] + comInput[18] + comInput[23];
	comsum[9] = comInput[4] + comInput[9] + comInput[14] + comInput[19] + comInput[24];
	// 대각선
	comsum[10] = comInput[0] + comInput[6] + comInput[12] + comInput[18] + comInput[24];
	comsum[11] = comInput[4] + comInput[8] + comInput[12] + comInput[16] + comInput[20];

	for (index1 = 0; index1 < 12; index1++)
		if (comsum[index1] == 0) comcount++;

	// 카운트
	//printf("usercount = %d\n", usercount);
	//printf("comcount = %d\n", comcount);

	if (usercount >= 5)
	{
		printf("\aYou Win!\n\n");
		endbingo();
		system("pause");
		game = 0;
	}
	else if (comcount >= 5)
	{
		printf("\aComputer Win!\n\n");
		endbingo();
		system("pause");
		game = 0;
	}
	else if ((usercount >= 5) && (comcount>=5))
	{
		printf("\aDraw!\n\n");
		endbingo();
		system("pause");
		game = 0;
	}
}

void endbingo() // 게임 끝나고 결과 출력
{
	printf("  < Your Bingo > \n"); // 사용자 빙고판 출력
	printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 1, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 2);

	for (index1 = 0; index1 < 25; index1++)
	{

		if (userbingo[index1] == usernum || userbingo[index1] == comnum)
			printf("%c (%2d) ", 5, userbingo[index1]);

		else if (userbingo[index1] == usersave[index1])
			printf("%c (%2d) ", 5, usersave[index1]);

		else
			printf("%c  %2d  ", 5, userbingo[index1]);
		if (index1 > 0 && index1 % 5 == 4)
		{
			printf("%c\n", 5);
			printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 25, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 23);
		}
	}
	printf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
	printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 3, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 4);

	printf("\n\n");
	printf(" < Computer Bingo > \n"); // 컴퓨터 빙고판 출력
	printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 1, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 22, 6, 6, 6, 6, 6, 6, 2);

	for (index1 = 0; index1 < 25; index1++)
	{
		if (combingo[index1] == usernum || combingo[index1] == comnum)
			printf("%c (%2d) ", 5, combingo[index1]);

		else if (combingo[index1] == comsave[index1])
			printf("%c (%2d) ", 5, comsave[index1]);

		else
			printf("%c  %2d  ", 5, combingo[index1]);
		if (index1 > 0 && index1 % 5 == 4)
		{
			printf("%c\n", 5);
			printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 25, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 16, 6, 6, 6, 6, 6, 6, 23);
		}
	}
	printf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
	printf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n", 3, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 21, 6, 6, 6, 6, 6, 6, 4);
}
