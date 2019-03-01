n=int(input())
num_list=[int (i) for i in input().split()]
num_list.sort()
cnt=0
i,length=0,len(num_list)-1
while i<length:
    if num_list[i]+num_list[length]==n:
        cnt+=1
        length-=1
    elif num_list[i]+num_list[length]>n:
        length-=1
    else:
        i+=1
print(cnt)