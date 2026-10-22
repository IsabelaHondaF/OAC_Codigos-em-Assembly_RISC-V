.data
STRING: .string "Modulo="

.text
.globl main
main:
    # --- Leitura de x ---
    li a7, 6                    # syscall 6: read_float
    ecall                       # Lê o float e armazena em fa0
    fmv.s ft0, fa0              # ft0 = x

    # --- Leitura de y ---
    li a7, 6                    # syscall 6: read_float
    ecall                       # Lê o float e armazena em fa0
    fmv.s ft1, fa0              # ft1 = y

    # --- Cálculo: modulo = sqrt(x*x + y*y) ---
    fmul.s ft0, ft0, ft0        # ft0 = x * x
    fmul.s ft1, ft1, ft1        # ft1 = y * y
    fadd.s ft2, ft0, ft1        # ft2 = x*x + y*y
    fsqrt.s fa0, ft2            # fa0 = sqrt(ft2)

    # --- Exibição do Resultado ---
    la a0, STRING               # Carrega a string "Modulo="
    li a7, 4                    # syscall 4: print_string
    ecall

    li a7, 2                    # syscall 2: print_float (valor em fa0)
    ecall

    li a7, 10                   # syscall 10: exit
    ecall                       # Encerra o programa