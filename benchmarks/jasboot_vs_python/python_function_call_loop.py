def inc(u: int) -> int:
    return u + 1


i = 0
while i < 5000:
    i = inc(i)

print(i)
