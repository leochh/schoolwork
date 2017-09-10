num_str = input('Enter a number: ')
precision_str = input('Enter a precision: ')
num = float(num_str)
precision = float(precision_str)

def compute(numt, precisiont):
    def rec(xn, oldxn):
        if abs(xn - oldxn) < precisiont:
            return 1
        oldxn = xn
        print(oldxn)
        xn = xn - ((xn * xn * xn - numt) / (3 * xn * xn))
        return rec(xn, oldxn)
    rec(50, 0)

compute(num, precision)
