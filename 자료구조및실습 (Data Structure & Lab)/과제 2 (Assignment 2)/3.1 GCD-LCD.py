def find_gcd_lcd(a, b):
    lcd = a * b
    while a != 0 and b != 0:
        if a > b:
            a%=b
        else:
            b%=a
    gcd = a+b
    lcd//=gcd
    return gcd, lcd

a, b = input().split()
a, b = int(a), int(b)
print(find_gcd_lcd(a, b))


"""def find_gcd_lcd(a, b):
    def _gcd(x, y):
        if y == 0: return x
        return (y, x % y)
    g = _gcd(a, b)
    return (g, a * b // g)

a, b = input().split()
a, b = int(a), int(b)
print(find_gcd_lcd(a, b))"""

"""
from fractions import gcd
def gcdlcm(a, b):
    return [gcd(a,b), a*b/gcd(a,b)]

a, b = input().split()
a, b = int(a), int(b)
print(gcdlcm(3,12))
"""
