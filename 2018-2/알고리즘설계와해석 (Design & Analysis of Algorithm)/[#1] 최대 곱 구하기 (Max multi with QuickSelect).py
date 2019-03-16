def QuickSelect(L,k):
    A, M, B = [], [] ,[]
    p=L[0]
    for a in L:
        if a<p: A.append(a)
        elif a==p:M.append(a)
        else: B.append(a)
    if len(A) >= k: return QuickSelect(A,k)
    elif len(A)+len(M) < k: return QuickSelect(B, k-len(A)-len(M))
    else: return p

def num3(card):
    pos, neg, zero=0, 0, 0                              # 양수, 음수, 0
    m=1                                                 # 곱셈을 위해 1로 설정
    max=1                                               # 음수 곱셈을 하여 가장 큰 수 찾기
    for i in card:                                      # 양수와 음수의 갯수로 연산방법 결정
        if i==0: zero+=1
        elif i>0: pos+=1
        elif i<0: neg+=1

    if pos==3:                                          # 양수 3
        for i in card:
            m*=i
        return m

    elif pos==2 and (neg==1 or zero==1):                # 양수 2, 음수 1 or 0 1
        for i in card:
            if i>0:
                m*=i
        return m

    elif neg==2:                                        # 음수 2 , 양수 1 or 0 1
        if pos==1:
            for i in card:
                m*=i
        if zero==1:
            for i in card:
                if i<0:
                    m*=i
        return m

    elif neg==3:                                         # 음수 3
        for i in range(1,3):
            m*=QuickSelect(card,i)
        return m

    else:                                                # 나머지 경우 (양 1, 0 2 / 음 1, 0 2 / 양 1, 0 1, 음 1)
        for i in card:
            m*=i
        return m

def num(card):
    pos, neg, zero = 0, 0, 0  # 양수, 음수, 0
    m = 1  # 곱셈을 위해 1로 설정
    max = 1  # 음수 곱셈을 하여 가장 큰 수 찾기
    for i in card:  # 양수와 음수의 갯수로 연산방법 결정
        if i == 0: zero += 1
        elif i > 0: pos += 1
        elif i < 0: neg += 1

    if pos>=3:                                            # 양수 3개 이상 가장 큰거 3개 곱
        try:
            for i in range(0,3):
                m*=QuickSelect(card,len(card)-i)
        except RecursionError:
            n=card[0]
            temp=0
            for i in card:
                if i>=m:
                    temp=m
                    m=i
                elif i>=n:
                    n*=i
                    continue
            if temp<n:
                m*=n
            else:
                m*=temp
        return m

    elif pos>=2 and (zero<2 or neg<2):
        for i in range(0,2):
            m*=QuickSelect(card,len(card)-i)
        return m

    elif neg>=2:                                          # 음수 2개 이상
        for i in range(1,3):
                max*=QuickSelect(card,i)

        if zero==0 and pos==0:                            # 음수만 있는 경우
            return max

        elif zero>=1 and pos==0:                          # 0 1개 있을 경우 가장 큰 음수 곱
            return max

        elif pos==1:                                      # 양수 1개 있을 경우 가장 큰 음수 곱
            m=QuickSelect(card,len(card))
            m*=max
            return m

        elif pos>=2:                                      # 양수 2개 이상 있을 경우
            if max>QuickSelect(card,len(card)-1):         # 음수 2개 곱이 두번쨰로 큰 수 보다 크면 max*가장 큰 양수
                m=QuickSelect(card,len(card))*max
            else:                                         # 아니라면 가장 큰 양수 * 두번째로 큰 양수
                for i in range(0,2):
                    m*=QuickSelect(card,len(card)-i)
            return m

    else:                                                 # 나머지 경우
        for i in card:
            m*=i
        return m

n=int(input())
card=[int (i) for i in input().split()]
if len(card)==3:
    print(num3(card))
elif len(card)>3:
    print(num(card))
