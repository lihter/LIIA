#include "arm_syscall.h"

void assembly_deny_debugger_attach() {
    __asm (
           "mov x0, #31\n" // x0 = #define PT_DENY_ATTACH 31

           // ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0)
           "mov x1, #0\n" // clear x1
           "mov x2, #0\n" // clear x2
           "mov x3, #0\n" // clear x3

           "mov x16, #26\n" // x16 = syscal 26, invoke ptrace

           "svc #0x80\n" // supervisor call (normally used for privileged access and operations of an operating system)
           );
}
