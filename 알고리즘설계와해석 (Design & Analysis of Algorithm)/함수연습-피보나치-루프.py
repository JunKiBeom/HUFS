def fibo(n):
    head = 1;
    mid = 0;
    rear = 1;
    loop=0
    while loop<n:
        mid = head + rear
        head = rear
        rear = mid
        loop+=1
    return head

n=int(input())
print(fibo(n))