#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <Windows.h>
#pragma warning (disable:4996)

int main()
{
	char check;
	int answer, score;
	int fscore = 0, lscore = 0, quiz = 1; // fscore ��������, lscore �������� ����, quiz ���� ���Ƚ�� �� ���� ��ȣ
	clock_t start, end; // �� �ɸ��ð� ���
	clock_t input, output; // �Է½ð� �� ���� ���

game:
	{
		fscore = 0, quiz = 1; // �ٽ� ���ӽ� ���� ������ ���� �� �ʱ�ȭ

		printf("�������� ����. ���� ���� ��� �� 3�� �̳��� �Է��ϼ���.\n�غ��ϼ���.\n");
		for (int i = 3; i >= 0; i--)
		{
			if (i == 0)
				printf("Start~!\n");

			else
			{
				printf("%d����\n", i);
				Sleep(1000); // 1�ʰ��� ���
			}
		}

		start = clock(); // ���� ���� ���� �ð�
		for (quiz; quiz <= 10; quiz++)
		{
			srand((unsigned)time(NULL)); // ����
			int num1 = rand() % 9 + 1;
			int num2 = rand() % 9 + 1;

			printf(" %d) %d * %d =",quiz, num1, num2);
			output = clock(); // ��� �ð�
			scanf("%d", &answer);
			input = clock(); // �Է½ð�

			score = 3000 - (input - output); // ���� ���

			if (score <= 0) // 3�� �ƿ�
			{
				printf("(���ѽð��� �������ϴ�) Score = %d\n", fscore);
			}
			else if (answer == num1*num2)
			{
				fscore += score;
				printf("(�¾ҽ��ϴ�.) Score = %d\n", fscore);
			}
			else if (answer != num1*num2)
			{
				printf("(Ʋ�Ƚ��ϴ�.) Score =  %d\n", fscore);
			}
			printf("\n"); // �������� ���� �� �� ���
		}
		end = clock(); // ���� ���� �� �ð�
	}
	if (fscore > lscore)
		printf("\a�����մϴ�! �ְ����Դϴ�!\n"); // �ְ� ���� �޼��� ����� ��°� ���ϸ޽��� ���

	printf("�� �ɸ��ð���  %.lf�� �̸� ������ %d�� �Դϴ�..\n\n", (double)(end - start) / 1000, fscore);

	if (fscore>lscore)
		lscore = fscore; // ���� ���� ����

	while (1) // �߸��Է¹����� �ٽ� �Է¹ޱ����� ��ġ
	{
		printf("������ ��� �Ͻðڽ��ϱ�? (Y/N)");
		scanf(" %c", &check);

		if (check == 'Y')
			goto game; // ���� ���������� ���ư�. �ٽ� ����

		else if (check == 'N')
		{
			printf("�ְ������� %d�� �Դϴ�..\n������ �����մϴ�.\n",lscore);
			break;
		}
	}
	return 0;
}