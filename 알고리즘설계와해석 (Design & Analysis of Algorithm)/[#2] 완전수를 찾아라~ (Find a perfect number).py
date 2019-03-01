import math
def div(n):
    sum=0
    for i in range(1,math.ceil(math.sqrt(n))):
        if (n % i == 0):
            sum+=i
            if not (n/i)==n:
                sum+=(n/i)
    return sum

n=int(input())
if div(n)==n:
    print("YES")
else:
    print("NO")
