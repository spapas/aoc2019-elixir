import re

with open('day22.txt') as file:
    input = file.read()

rules = input.split('\n')

# convert rules to linear polynomial.
# (g∘f)(x) = g(f(x))
def parse(L, rules):
    a,b = 1,0
    for s in rules[::-1]:
        print(a,b )
        if s == 'deal into new stack':
            a = -a
            b = L-b-1
            continue
        if s.startswith('cut'):
            n = int(s.split(' ')[1])
            b = (b+n)%L
            continue
        if s.startswith('deal with increment'):
            n = int(s.split(' ')[3])
            z = pow(n,L-2,L) # == modinv(n,L)
            print("ZZZZ", z)
            a = a*z % L
            b = b*z % L
            continue
        raise Exception('unknown rule', s)

    return a,b

# modpow the polynomial: (ax+b)^m % n
# f(x) = ax+b
# g(x) = cx+d
# f^2(x) = a(ax+b)+b = aax + ab+b
# f(g(x)) = a(cx+d)+b = acx + ad+b
def polypow(a,b,m,n):
    if m==0:
        return 1,0
    if m%2==0:
        return polypow(a*a%n, (a*b+b)%n, m//2, n)
    else:
        c,d = polypow(a,b,m-1,n)
        return a*c%n, (a*d+b)%n

def shuffle2(L, N, pos, rules):
    a,b = parse(L,rules)
    print(a,b)
    a,b = polypow(a,b,N,L)
    print(a,b)
    return (pos*a+b)%L

L = 119315717514047
N = 101741582076661
print(shuffle2(L,N,2020,rules))