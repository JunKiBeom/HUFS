import math

a=float(input())
b=float(input())
c=float(input())

D=b**2-4*a*c

if a==0:
    try:
        x=-c/b
        if x==-0:
            x=0
        print("%.3f"%x)
    except ZeroDivisionError:
        print("ZeroDivision")

elif a==0 and c==0:
    x=0
    print("%.3f"%x)

elif b==0 and c==0 :
    x=0
    print("%.3f"%x)

elif D>0:
    x=((-b+math.sqrt(D))/(2*a))
    y=((-b-math.sqrt(D))/(2*a))
    if x==-0:
        x=0
    if y==-0:
        y=0
    print("%.3f,%.3f"%(x,y))

elif D==0:
    x=(-b/2*a)
    print("%.3f"%x)

elif D<0:
    x=(-b/(2*a))
    if x==-0:
        x=0
    i=math.sqrt(D*-1)/(2*a)
    if i<0:
        i*=-1
    print("%.3f+%.3fi,%.3f-%.3fi"%(x,i,x,i))

