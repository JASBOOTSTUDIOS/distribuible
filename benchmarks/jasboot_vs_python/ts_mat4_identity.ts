function mat4Mul(a: number[], b: number[]): number[] {
    const out = new Array<number>(16).fill(0);
    for (let r = 0; r < 4; r++) {
        const base = r * 4;
        for (let c = 0; c < 4; c++) {
            out[base + c] =
                a[base + 0] * b[c + 0] +
                a[base + 1] * b[c + 4] +
                a[base + 2] * b[c + 8] +
                a[base + 3] * b[c + 12];
        }
    }
    return out;
}

const identity = [
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0,
];

let acc = identity.slice();
let tmp = identity.slice();
for (let i = 0; i < 50000; i++) {
    tmp = mat4Mul(acc, identity);
    acc = mat4Mul(tmp, identity);
}

console.log(acc[0].toFixed(4));
console.log("");
