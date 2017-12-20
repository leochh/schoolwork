def cal(t2):
    r1 = 2/3 * t2
    print("r1 is {}".format(r1))
    r2 = 2/3 * (10 + t2 - ((10 * t2) / (10 + t2)))
    print("r2 is {}".format(r2))
    if t2 != ((r1 + r2) / 2):
        t2 = (r1 + r2) / 2
        print("t2 is {}".format(t2))
        cal(t2)
    else:
        return True

cal(5)
