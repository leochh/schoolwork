import math

num_str = input("Enter a number: ")
precision_str = input("Enter a precision: ")
num = float(num_str)
precision = math.pow(0.1,float(precision_str))

def compute(low, high, oldmid, mid):
    t = 0
    while abs(oldmid - mid) > precision:
        oldmid = mid
        midcube = mid * mid * mid
        if num > 0:
            if midcube > num:
                high = mid
            else:
                low = mid
        else:
            if midcube < num:
                high = mid
            else:
                low = mid
        mid = (low + high) / 2
        t += 1
        print(str(t) + " " + str(mid))

if abs(num)>=1:
    low = 0
    high = num
    oldmid = num
    mid = (low + high) / 2
else:
    low = num
    oldmid = num
    if num>0:
        high = 1
    else:
        high = -1
    mid = (low + high) / 2
compute(low, high, oldmid, mid)
