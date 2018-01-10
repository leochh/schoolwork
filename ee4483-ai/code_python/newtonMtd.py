import math

num_str = input('Enter a number: ')
precision_str = input('Enter the number of precision digit(integer): ')
num = float(num_str)
precision = math.pow(0.1,float(precision_str))

def compute(initialValue, precisionDigit):
    def rec(xn, oldxn, t):
        if abs(xn - oldxn) < precisionDigit:
            return True
        oldxn = xn
        t = t + 1
        print(str(t) + " " + str(oldxn))
        xnplusone = xn - ((xn * xn * xn - initialValue) / (3 * xn * xn))
        return rec(xnplusone, oldxn, t)
    rec(50, 0, 0)

compute(num, precision)
