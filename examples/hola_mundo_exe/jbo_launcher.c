/*
 * Launcher nativo (PE): ejecuta hola_mundo.jbo con jasboot-ir-vm.exe.
 * Jasboot no genera .exe directamente; el binario del programa es el .jbo.
 */
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void dirname_of_exe(char *buf, size_t cap) {
    if (!GetModuleFileNameA(NULL, buf, (DWORD)cap))
        buf[0] = '\0';
    else {
        char *p = strrchr(buf, '\\');
        if (p) *p = '\0';
    }
}

static int path_exists(const char *p) {
    return GetFileAttributesA(p) != INVALID_FILE_ATTRIBUTES;
}

int main(void) {
    char base[MAX_PATH];
    dirname_of_exe(base, sizeof base);
    if (!base[0]) {
        fprintf(stderr, "hola_mundo: sin directorio del modulo\n");
        return 1;
    }

    char jbo_rel[MAX_PATH * 2];
    char jbo_abs[MAX_PATH * 2];
    snprintf(jbo_rel, sizeof jbo_rel, "%s\\hola_mundo.jbo", base);
    if (!GetFullPathNameA(jbo_rel, (DWORD)sizeof jbo_abs, jbo_abs, NULL)) {
        fprintf(stderr, "hola_mundo: ruta .jbo invalida\n");
        return 1;
    }
    if (!path_exists(jbo_abs)) {
        fprintf(stderr, "hola_mundo: no existe %s\nCompile: jbc hola_mundo.jasb -o hola_mundo.jbo\n", jbo_abs);
        return 1;
    }

    char try_vm[MAX_PATH * 2];
    char vm_abs[MAX_PATH * 2];
    const char *candidates[] = {
        "\\..\\..\\sdk-dependiente\\jasboot-ir\\bin\\jasboot-ir-vm.exe",
        "\\..\\..\\..\\sdk-dependiente\\jasboot-ir\\bin\\jasboot-ir-vm.exe",
        "\\..\\sdk-dependiente\\jasboot-ir\\bin\\jasboot-ir-vm.exe",
    };
    vm_abs[0] = '\0';
    for (size_t i = 0; i < sizeof candidates / sizeof candidates[0]; i++) {
        snprintf(try_vm, sizeof try_vm, "%s%s", base, candidates[i]);
        if (GetFullPathNameA(try_vm, (DWORD)sizeof vm_abs, vm_abs, NULL) &&
            path_exists(vm_abs))
            break;
        vm_abs[0] = '\0';
    }
    if (!vm_abs[0]) {
        const char *ev = getenv("JASBOOT_VM");
        if (ev && ev[0] && path_exists(ev)) {
            strncpy(vm_abs, ev, sizeof vm_abs - 1);
            vm_abs[sizeof vm_abs - 1] = '\0';
        }
    }
    if (!vm_abs[0]) {
        fprintf(stderr,
                "hola_mundo: no se encontro jasboot-ir-vm.exe desde %s\n"
                "Defina JASBOOT_VM=ruta\\completa\\jasboot-ir-vm.exe\n",
                base);
        return 1;
    }

    char cmdline[32768];
    int n = snprintf(cmdline, sizeof cmdline, "\"%s\" \"%s\"", vm_abs, jbo_abs);
    if (n < 0 || (size_t)n >= sizeof cmdline) {
        fprintf(stderr, "hola_mundo: linea de comando demasiado larga\n");
        return 1;
    }

    STARTUPINFOA si;
    PROCESS_INFORMATION pi;
    memset(&si, 0, sizeof si);
    si.cb = sizeof si;

    char *mutable = (char *)malloc((size_t)n + 2);
    if (!mutable) return 1;
    memcpy(mutable, cmdline, (size_t)n + 1);

    if (!CreateProcessA(NULL, mutable, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
        fprintf(stderr, "hola_mundo: CreateProcess error %lu\n", (unsigned long)GetLastError());
        free(mutable);
        return 1;
    }
    free(mutable);

    WaitForSingleObject(pi.hProcess, INFINITE);
    DWORD code = 1;
    GetExitCodeProcess(pi.hProcess, &code);
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
    return (int)code;
}
