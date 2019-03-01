"""
str=input()
sum=0
try:
    if ' ' in str:
        num=str.split(' ')
        num=list(set(num))
    else:
        num=list(set(str))
    if '' in num:
        num.remove('')
    num=[int(i) for i in num]
    for i in range(0,len(num)):
        sum+=num[i]
    print(sum)
except ValueError:
    print(error)
"""
print(sum(list(set([int (i) for i in input().split()]))))
#print(num)
