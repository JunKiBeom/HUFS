#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>


//Include a char in answer string if the char is correctly guessed
//Then, check if the answer string is the same as the word
int check(char ch, char word[40], char answer[40], int s)
{
    for(int i=0;i<s;i++)
    {
        if(word[i]==ch)  // 단어랑 입력한거랑 일치하면
            answer[i]=ch;  // _제거하고 단어 보여줌
    }
    return 0;  // 사실상 필요가 없음 void형 써도 무방
}

//Check if a char is in user guess array
int is_in_guess(char ch, char guess[40], int s)
{
    int confirm=1;  // 아래서 동작 유무을 위해서
    for (int i=0;i<s;i++)
    {
        if(guess[i]==ch)  // 이미 입력한거면 동작 안함
            confirm=0;
    }
    return confirm;  // 값 반환
}

//Get one char from the keyboard
char get_one_char()  // 키보드로 글자 하나 입력 받음
{
    int ch;
    
    ch=getchar();
    while(getchar()!='\n');
    
    return ch;
}

//Pick a word whose size>=5 in a random way from a file
void pick_random_word(FILE *fp, char word[40], int len, int n)
{
    int line=rand()%n;  // 랜덤으로 읽을 라인
    fp=fopen("/Users/junkibeom/Desktop/voca3000.txt","r");  // 파일 경로 및 읽기
    
    for(int i=0;i<line;i++)
        fscanf(fp,"%s", word);  // fscanf로 단어 불러오기, word에 저장
    while(1)
    {
        if (len>strlen(word))  // 길이가 5보다 작으면
        {
            line=rand()%n;  // 새로운 줄의 단어를 찾아 넣기
            fscanf(fp,"%s", word);
        }
        else
            break;  // 길이가 5보다 긴 단어면 word에 넣고 함수 탈출
    }
}

//Initialize an answer string to all underscore('_') chars
void init_answer(char answer[40], int s)
{
    for(int i=0;i<s;i++)
        answer[i]='_';  // 단어 길이만큼 _로 초기화 (단어 가리기)
    answer[s+1]='\0';  // 바로 뒷부분 공백문자로 초기화
}

int main()
{
    FILE *fp=fopen("/Users/junkibeom/Desktop/voca3000.txt","r");
    if(fp==NULL)
    {
        printf("No file found\n");
        exit(0);
    }  // 파일을 못 불러오면 경고문 출력 후 프로그램 종료
    
    int n=3000;  // 등록된 단어의 개수
    char word[40]={0};  // 단어 저장 배열
    char ch;  // 입력받을 문자
    int index=0;  // guess에 단어를 저장하기 위해 사용하는 변수
    
    srand((int)time(NULL));  // 랜덤 생성을 위해 사용
    
    //pick a word from voca3000.txt.
    //The length of the word must be>=5
    pick_random_word(fp,word,5,n);  // 파일에서 길이가 5보다 긴 단어 불러오기
    int s=strlen(word);  // 단어의 길이를 s라는 변수에 저장, '_'를 표현하기 위함
    
    char answer[40]={0}; // array for storing chars of correctly guessed parts  정답 부분 저장
    char guess[40]={0}; // array for storing chars of guessed by the user       입력 부분 저장
    guess[0]='\0';
    init_answer(answer,s); // Initially, all underscores  정답을 '_'로 가림
    
    printf("word: %s\n",word);  // 채점의 편의를 위해서 정답 출력
    
    while(1)
    {
        for (int i=0, cnt=0;i<s;i++)  // cnt로 카운트
        {
            if (word[i]==answer[i])  // word와 answer에서 같은 단어 갯수 파악, 맞으면 1씩 증가
                cnt++;
            if (cnt==s) // 카운트한 숫자가 단어의 길이와 같다면 답 출력하고 프로그램 종료
            {
                printf("\n%s\n",answer);
                exit(0);
            }
        }
        printf("\n%s\n",answer);  // _와 맞은 단어들 출력
        printf("%s: ",guess); // 사용자가 입력한것들 출력
        ch=get_one_char(); // 입력 함수
        check(ch, word, answer, s); // 입력과 정답을 전달
        if (is_in_guess(ch, guess, s))  // 입력을 했는지 확인하는 함수, return값을 사용하여 조건문 판별
        {
            guess[index]=ch;  // guess배열에 단어 넣기
            index++; // 이미 있는 단어 겹치지 않게, 사용자가 넣은 순서대로 나오도록 증가 시켜주기
        }
    }
}
