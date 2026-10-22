.data
VET:    .space 40
STRING: .string "media="

.text
.globl main
main:
    li s0, 10
    la s1, VET

    li t0, 0 #contador começa em 0
    mv t1, s1 #o endereço base do vetor é passado para t1

SCAN:
    beq t0, s0, ENDSCAN #se o contador t0 chegar a 10, termina o loop

    li a7, 5
    ecall
    sw a0, 0(t1) #registra no espaço do vetor de endereço t1

    addi t0, t0, 1
    addi t1, t1, 4 #endereços pulam de 4 em 4
    j SCAN

ENDSCAN:
    mv a0, s1
    mv a1, s0
    
    li t0, 0
    fcvt.s.w fa0, zero

SOMA:
    beq t0, a1, MEDIA #se o contador t0 chegar a 10, termina o loop

    lw t2, 0(a0) #pega o que está no vetor na posição a0 e passa para t2
    fcvt.s.w ft1, t2
    fadd.s fa0, fa0, ft1

    addi t0, t0, 1
    addi a0, a0, 4
    j SOMA

MEDIA:
    fcvt.s.w ft1, a1 #conversão de a0 para float
    fdiv.s fa0, fa0, ft1 #média

    la a0, STRING #media=
    li a7, 4
    ecall

    li a7, 2 #escreve o valor armazenado em fa0
    ecall

    li a7, 10
    ecall
