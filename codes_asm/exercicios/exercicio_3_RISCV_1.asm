.data
VET:    .space 40               # Vetor com 10 inteiros (10 * 4 bytes)
ESPACO: .string " "

.text
.globl main
main:
    # --- Inicialização ---
    li s0, 10                   # s0 = Tamanho do vetor (limite)
    la s1, VET                  # s1 = Endereço base do vetor

    li t0, 0                    # t0 = Contador de iterações (i = 0)
    mv t1, s1                   # t1 = Ponteiro para percorrer o vetor

    # --- Loop de Leitura (Input) ---
SCAN:
    beq t0, s0, ENDSCAN         # Se i == 10, sai do loop

    li a7, 5                    # syscall 5: read_int
    ecall                       # Lê o inteiro e armazena em a0

    sw a0, 0(t1)                # VET[i] = a0

    addi t0, t0, 1              # Incrementa o contador
    addi t1, t1, 4              # Move o ponteiro para próximo int (+4 bytes)
    j SCAN

ENDSCAN:
    # --- Chamada da Função ORDENA ---
    mv a0, s1                   # Argumento 1: Endereço do vetor
    mv a1, s0                   # Argumento 2: Tamanho do vetor
    jal ORDENA                  # Chama a sub-rotina (ordena o vetor na memória)

    # --- Chamada da Função IMPRIME ---
    mv a0, s1                   # Argumento 1: Endereço do vetor
    mv a1, s0                   # Argumento 2: Tamanho do vetor
    jal IMPRIME                 # Chama a sub-rotina (imprime o vetor)

    li a7, 10                   # syscall 10: exit
    ecall                       # Encerra o programa

# --- Sub-rotina: ORDENA (bubble sort) ---
# Argumentos: a0 (endereço base do vetor), a1 (tamanho do vetor)
# Retorno: nenhum (o vetor é ordenado na própria memória)
ORDENA:
    addi t6, a1, -1             # t6 = n - 1
    li t0, 0                    # i = 0

ORD_EXT:
    beq t0, t6, ORD_FIM         # Se i == n-1, terminou
    li t1, 0                    # j = 0
    sub t2, t6, t0              # Limite do loop interno = n - 1 - i
    mv t3, a0                   # t3 = Ponteiro para VET[j]

ORD_INT:
    beq t1, t2, ORD_PROX        # Se j == limite, próxima passada
    lw t4, 0(t3)                # t4 = VET[j]
    lw t5, 4(t3)                # t5 = VET[j+1]
    ble t4, t5, ORD_OK          # Se VET[j] <= VET[j+1], não troca
    sw t5, 0(t3)                # VET[j] = VET[j+1]
    sw t4, 4(t3)                # VET[j+1] = VET[j] (antigo)

ORD_OK:
    addi t1, t1, 1              # Incrementa j
    addi t3, t3, 4              # Próxima posição no vetor
    j ORD_INT

ORD_PROX:
    addi t0, t0, 1              # Incrementa i
    j ORD_EXT

ORD_FIM:
    ret                         # Retorna para o ponto de chamada

# --- Sub-rotina: IMPRIME ---
# Argumentos: a0 (endereço base do vetor), a1 (tamanho do vetor)
# Retorno: nenhum (imprime os valores separados por espaço)
IMPRIME:
    li t0, 0                    # Zerar contador interno
    mv t1, a0                   # t1 = Ponteiro para percorrer o vetor

IMP_LOOP:
    beq t0, a1, IMP_FIM         # Se percorreu todo o vetor, termina
    beqz t0, IMP_NUM            # Não imprime espaço antes do primeiro

    la a0, ESPACO               # Carrega a string " "
    li a7, 4                    # syscall 4: print_string
    ecall

IMP_NUM:
    lw a0, 0(t1)                # Carrega o inteiro atual do vetor
    li a7, 1                    # syscall 1: print_int
    ecall

    addi t0, t0, 1              # Incrementa contador
    addi t1, t1, 4              # Próxima posição no vetor
    j IMP_LOOP

IMP_FIM:
    ret                         # Retorna para o ponto de chamada