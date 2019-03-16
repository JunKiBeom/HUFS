# -*- coding: utf-8 -*-
# UTF-8 encoding when using korean

def is_common_subsequence(X, Y, S):
    return is_subsequence(X, S) and is_subsequence(Y, S)

def is_subsequence(X, S):
    n = len(X)
    m = len(S)
    i = 0
    j = 0
    assert (m <= n)
    while j < m and i < n:
        if S[j] == X[i]:
            j = j + 1
        i = i + 1
    return j == m

def find_LCS(X, Y):
# code here!
    X,Y="0"+X,"0"+Y
    #print(X,Y)
    LCS_Len=0
    table=[[0 for i in range (len(X))] for j in range (len(Y))]

    '''for i in range(len(Y)):
        for j in range(len(X)):
            print(table[i][j],end="")
        print()'''

    for i in range(1,len(Y)):
        max = 0
        table[i][0]=0
        temp1, temp2 = 0, 0
        for j in range(1,len(X)):
            if Y[i]==X[j]:
                max=table[i-1][j-1]+1
                table[i][j]=max
            else:
                if(table[i][j-1]>table[i-1][j]):
                    table[i][j]=table[i][j-1]
                else:
                    table[i][j]=table[i-1][j]
        if LCS_Len<max:
            LCS_Len=max

    temp_len1=LCS_Len
    temp_len2=LCS_Len-1
    LCS=""
    temp=len(X)-1
    for i in range(len(Y)-1,0,-1):
        for j in range(temp,0,-1):
            if (table[i][j]==temp_len1 and table[i][j-1]==temp_len2 and table[i-1][j-1]==temp_len2 and table[i-1][j]==temp_len2):
                temp_len1-=1
                temp_len2-=1
                LCS=Y[i]+LCS
                temp=j
                break

    return LCS_Len, LCS

# return length of LCS and any LCS

# don't touch the code below!
X = input().strip()
Y = input().strip()
k, S = find_LCS(X, Y)  # take the length k and LCS S
print(k)
print(is_common_subsequence(X, Y, S))