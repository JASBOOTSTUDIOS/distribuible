s = "a"
for _ in range(3000):
    s += ",a"
parts = s.split(",")
print(len(parts))
print("")
