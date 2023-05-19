#ifndef arm_syscall_h

#define arm_syscall_h
#include <stdio.h>
void assembly_deny_debugger_attach(void) __attribute__((always_inline));

#endif /* arm_syscall_h */
