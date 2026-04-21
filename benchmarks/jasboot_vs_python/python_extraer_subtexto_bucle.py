s = "x"
for _ in range(95000):
    s += " ab "
    s += "Jefry Astacio"

tmp = ""
for _ in range(3000000):
    tmp = s[0:120]

print(len(s))
print("")
print(tmp)
