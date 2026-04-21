def mat4_mul(a, b):
    out = [0.0] * 16
    for r in range(4):
        base_r = r * 4
        for c in range(4):
            out[base_r + c] = (
                a[base_r + 0] * b[c + 0]
                + a[base_r + 1] * b[c + 4]
                + a[base_r + 2] * b[c + 8]
                + a[base_r + 3] * b[c + 12]
            )
    return out


identity = [
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0,
]
acc = identity[:]
tmp = identity[:]

for _ in range(50000):
    tmp = mat4_mul(acc, identity)
    acc = mat4_mul(tmp, identity)

print(f"{acc[0]:.4f}")
print("")
