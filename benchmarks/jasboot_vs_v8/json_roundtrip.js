const payload = "{\"user\":\"ana\",\"hits\":[1,2,3,4],\"ok\":true,\"value\":12}";
let acc = 0;

for (let i = 0; i < 2000; i++) {
  const root = JSON.parse(payload);
  acc += root.hits[0];
  acc += root.hits[3];
  acc += root.ok ? 1 : 0;
  acc += root.value;
  acc += root.user.length;
  acc += JSON.stringify(root).length;
}

console.log(acc);
