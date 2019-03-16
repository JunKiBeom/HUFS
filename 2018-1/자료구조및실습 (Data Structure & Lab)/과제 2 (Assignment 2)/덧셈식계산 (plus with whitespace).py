"""
    정답코드
str=input()
num=str.split('+')
numls= [int (i) for i in num]
for i in range (1, len(numls)):
    numls[0]+=numls[i]
print(numls[0])
"""

print(sum([int (i) for i in input().split('+')]))
#print(num)
