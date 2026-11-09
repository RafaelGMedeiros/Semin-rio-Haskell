/* comparacao_switch.c: o mesmo mover do robo em C, com switch.
   Compilar: gcc -Wall comparacao_switch.c -o comparacao
   Executar: ./comparacao */
#include <stdio.h>

typedef struct { int x; int y; } Posicao;

/* Versao correta: um break por caso, default para comando desconhecido. */
Posicao mover(char c, Posicao p) {
    switch (c) {
        case 'N': p.y++; break;
        case 'S': p.y--; break;
        case 'L': p.x++; break;
        case 'O': p.x--; break;
        default: break;
    }
    return p;
}

/* Versao com break esquecido no caso 'N': o comando cai no caso 'S'
   (fall-through) e as duas acoes acontecem. Em Haskell nao existe isso:
   cada equacao e independente. */
Posicao moverComBug(char c, Posicao p) {
    switch (c) {
        case 'N': p.y++;        /* break esquecido */
        case 'S': p.y--; break;
        case 'L': p.x++; break;
        case 'O': p.x--; break;
        default: break;
    }
    return p;
}

int main(void) {
    Posicao inicio = {0, 0};
    Posicao a = mover('N', inicio);
    Posicao b = moverComBug('N', inicio);
    printf("mover 'N' (0,0)        -> (%d,%d)\n", a.x, a.y);
    printf("moverComBug 'N' (0,0)  -> (%d,%d)\n", b.x, b.y);
    return 0;
}
