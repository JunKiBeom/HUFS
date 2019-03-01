import random, time

def quick_sort(A, first, last):
    if first>=last: return
    global cmp_q,move_q
    left,right=first+1,last
    pivot=A[first]

    while left<=right:
        while left<=last and A[left]<pivot:
            left+=1
            cmp_q+=1

        while right>first and A[right]>pivot:
            right-=1
            cmp_q+=1

        if left<right:
            A[left],A[right]=A[right],A[left]
            left+=1
            right-=1
            move_q+=3

    A[first],A[right]=A[right],A[first]
    move_q+=3

    quick_sort(A,first,right-1)
    quick_sort(A,right+1,last)
    return cmp_q,move_q

def merge_sort(A, first, last):
    if first >= last: return
    global cmp_m,move_m
    m = (first + last) // 2
    merge_sort(A, first, m)
    merge_sort(A, m + 1, last)
    B = []
    i = first
    j = m + 1

    while i <= m and j <= last:
        if A[i] <= A[j]:
            B.append(A[i])
            i += 1
            cmp_m+=1
        else:
            B.append(A[j])
            j += 1
            cmp_m+=1
    for i in range(i, m + 1):
        B.append(A[i])
    for j in range(j, last + 1):
        B.append(A[j])
    for k in range(first, last + 1):
        A[k] = B[k - first]
        move_m+=1
    return cmp_m, move_m

def check_sorted(A):
    sorted = True
    for i in range(n - 1):
        if A[i] > A[i + 1]: return False
    return True

n = int(input())
random.seed()
A, B = [], []

# A, B에 n개의 같은 랜덤 값을 만들어 저장한다
for i in range(n):
    num=random.randint(-1000,1000)
    A.append(num)
B=A[:]
cmp_q, move_q, cmp_m, move_m = 0, 0, 0, 0

'''print(A)
print("-"*50)'''

t0 = time.clock()
cmp_quick, move_quick = quick_sort(A, 0, n - 1)
t1 = time.clock()
cmp_merge, move_merge = merge_sort(B, 0, n - 1)
t2 = time.clock()

# 진짜 정렬되었는지 check한다 - check_sorted를 호출
assert (check_sorted(A))
assert (check_sorted(B))

print("Quick sort : n =", n)
print("time = {} seconds".format(t1 - t0))
print("comparisons = {}, moves = {}".format(cmp_quick, move_quick))
#print("\nResult :",A)
print("-"*50)
print("Merge sort : n =", n)
print("time = {} seconds".format(t2 - t1))
print("comparisons = {}, moves = {}".format(cmp_merge, move_merge))
#print("\nResult :",B)