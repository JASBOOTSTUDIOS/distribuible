s = "x"
for _ in range(800):
    s += "ab"

acc = 0
for _ in range(5000):
    acc += 1 if "ab" in s else 0
    acc += s.find("ab")
    acc += 1 if s.endswith("b") else 0

print(len(s))
print("")
print(acc)
print("")
