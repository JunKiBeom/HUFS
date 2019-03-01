def gcd_sub(a, b):
    while a * b != 0:
        if a > b:
            a = a - b
        else:
            b = b - a
    return a + b

def gcd_mod(a, b):
    while a * b != 0:
        if a > b:
            a = a % b
        else:
            b = b % a
    return a + b

def gcd_rec(a, b):
    if b == 0:
        return a
    return gcd_sub(a, b)    # return gcd_rec(b, a % b)도 가능

a, b = input().split()
a, b = int(a), int(b)
# a, b를 입력받는다
x = gcd_sub(a, b)
y = gcd_mod(a, b)
z = gcd_rec(a, b)
# gcd_sub, gcd_mod, gcd_rec을 각각 호출하여, x, y, z에 리턴값을 저장한다
print(x, y, z)