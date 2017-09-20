import math

num_str = input('Enter a number: ')
precision_str = input('Enter a precision: ')
num = float(num_str)
precision = math.pow(0.1,float(precision_str))

def compute(numt, precisiont):
    def rec(xn, oldxn, t):
        if abs(xn - oldxn) < precisiont:
            return 1
        oldxn = xn
        t = t + 1
        print(str(t) + " " + str(oldxn))
        xn = xn - ((xn * xn * xn - numt) / (3 * xn * xn))
        return rec(xn, oldxn, t)
    rec(50, 0, 0)

compute(num, precision)
