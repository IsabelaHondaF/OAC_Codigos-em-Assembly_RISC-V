# =====================================================================
# Programa: prog1.asm
# Descrição: Lê um número inteiro do teclado e escreve na tela o dobro
#            desse número (RV32IM).
# 
# Exemplo:
#   Input: 1
#   Resultado: 2
# =====================================================================

.text
.globl main
main:
    li a7, 5                    # syscall 5: read_int
    ecall                       # Lê o inteiro e armazena em a0

    li t0, 2
    mul a0, a0, t0              # Multiplica o valor de a0 por 2

    li a7, 1                    # syscall 1: print_int
    ecall                       # Imprime o valor de a0

    li a7, 10                   # syscall 10: exit
    ecall                       # Encerra o programa