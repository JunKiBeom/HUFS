import heapq
def Huffman(n,f):
    H=[]
    sum=0
    for x in range(n):
        heapq.heappush(H,(f[x],x))
    while len(H)>1:
        a=heapq.heappop(H)
        b=heapq.heappop(H)
        heapq.heappush(H,(a[0]+b[0],a[1]+b[1]))
        sum+=a[0]+b[0]
    return sum
f=[int(i) for i in input().split()]
n=len(f)
result=Huffman(n,f)
print(result)