const fs = require('fs');
let code = 'principal\n';
for (let i = 1; i <= 300; i++) {
    code += `    entero var_${i} = ${i}\n`;
}
code += '    imprimir var_300\n';
code += 'fin_principal\n';
fs.writeFileSync('C:/src/jasboot/tests/P0_03_entero_declaracion_asignacion/E/e_limite_registros.jasb', code);
