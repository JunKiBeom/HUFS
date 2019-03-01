import time, random

def Sum(A,n):
    X = [[0 for i in range(n)] for j in range(n)]
    for i in range(n):
        for j in range(i,n):
            X[i][j]=sum(A[i:j+1])
    return X


# code here

# n = 1 이상 5000 이하 정수 값 입력
n = int(input())
# 리스트 A에 랜덤 정수 값 n개 채움
A=[random.randint(0,100) for i in range(n)]
#n=3
#A=[87,5,39]
# sum 함수 호출 + 시간 측정
before = time.clock()
S=Sum(A,n)
after = time.clock()
#print(A)
print(S)
# 함수의 수행시간을 출력
print(after-before)
