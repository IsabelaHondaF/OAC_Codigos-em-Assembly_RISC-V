# =====================================================================
# Crie um programa em Assembly RISC-V (RV32IM) que leia um número inteiro 0<N<10000 do
# teclado e escreva na tela o enésimo número primo, Primo(N), onde Primo(1)=2.
#
# Apenas faça upload do arquivo 'prog1.asm' com o seu programa e submeta.
# Por exemplo:
# TesteInputResultado Trivial
# 1
# 1
# Primo(1)=2
# Trivial
# 2
# 2
# Primo(2)=3
# Negativo
# -2
# -2
#
# Program terminated by calling exit
# =====================================================================

.data
STR1: .string "Primo("
STR2: .string ")="

.text
.globl main
main:
    # --- Leitura de N ---
    li a7, 5                    # syscall 5: read_int
    ecall                       # Lê o inteiro e armazena em a0
    mv s0, a0                   # s0 = N

    # --- Validação: 0 < N < 10000 ---
    blez s0, FIM                # Se N <= 0, encerra sem imprimir
    li t0, 10000
    bge s0, t0, FIM             # Se N >= 10000, encerra sem imprimir

    # --- Chamada da Função PRIMO ---
    mv a0, s0                   # Argumento 1: N
    jal PRIMO                   # Chama a sub-rotina (resultado volta em a0)
    mv s1, a0                   # s1 = Primo(N)

    # --- Exibição do Resultado: Primo(N)=valor ---
    la a0, STR1                 # Carrega a string "Primo("
    li a7, 4                    # syscall 4: print_string
    ecall

    mv a0, s0                   # Imprime N
    li a7, 1                    # syscall 1: print_int
    ecall

    la a0, STR2                 # Carrega a string ")="
    li a7, 4                    # syscall 4: print_string
    ecall

    mv a0, s1                   # Imprime Primo(N)
    li a7, 1                    # syscall 1: print_int
    ecall

FIM:
    li a7, 10                   # syscall 10: exit
    ecall                       # Encerra o programa

# --- Sub-rotina: PRIMO ---
# Argumentos: a0 (N)
# Retorno: a0 (enésimo número primo)
PRIMO:
    li t0, 0                    # t0 = Quantidade de primos encontrados
    li t1, 1                    # t1 = Candidato atual

PRIMO_LOOP:
    addi t1, t1, 1              # Próximo candidato
    li t2, 2                    # t2 = primeiro divisor testado (d = 2)

TESTE:
    mul t3, t2, t2              # t3 = d * d
    bgt t3, t1, EH_PRIMO        # Se d*d > candidato, é primo
    rem t4, t1, t2              # t4 = candidato % d
    beqz t4, PRIMO_LOOP         # Se t4 for 0 eh divisivel, ent não é primo: próximo candidato
    addi t2, t2, 1              # Próximo divisor
    j TESTE

EH_PRIMO:
    addi t0, t0, 1              # Achou mais um primo
    bne t0, a0, PRIMO_LOOP      # Se ainda não chegou no N-ésimo, continua
    mv a0, t1                   # Retorna o primo encontrado
    ret                         # Retorna para o ponto de chamada