# Tema 05 - Pattern matching nos comandos de um robô

**Disciplina:** Programação Imperativa e Funcional (CESAR School, 2026.2)
**Professor:** Roni Maciel
**Equipe:** [nome da equipe]
**Integrantes:** [nome completo de cada integrante]

## Sobre o projeto

Controle de um robô em um plano cartesiano para investigar pattern matching em Haskell: padrões literais, curinga `_`, tuplas e listas `(c:cs)`. A posição é uma tupla `(x, y)` e os comandos são `'N'`, `'S'`, `'L'` e `'O'`.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `Exemplo1.hs` | Exemplo conceitual: padrões literais, curinga, tuplas, listas e ordem das equações |
| `Aplicacao.hs` | Aplicação prática: as cinco funções obrigatórias (`mover`, `executar`, `trajetoria`, `distanciaOrigem`, `quadrante`), a extensão (grade 10 x 10) e o `main` |
| `Experimentos.hs` | Experimentos do desafio investigativo (padrões incompletos e ordem das equações); carregar no GHCi |
| `comparacao_switch.c` | Versão em C com `switch`, incluindo o problema do `break` esquecido |
| `SINTESE.md` | Síntese das descobertas e referências |

## Como compilar e executar

Requer GHC (instalado pelo [GHCup](https://www.haskell.org/ghcup/)) e, para o arquivo em C, um compilador como o gcc.

Linux e macOS:

```bash
ghc -Wall Exemplo1.hs -o exemplo1
./exemplo1

ghc -Wall Aplicacao.hs -o aplicacao
./aplicacao

gcc -Wall comparacao_switch.c -o comparacao
./comparacao
```

Windows (PowerShell):

```powershell
ghc -Wall Exemplo1.hs -o exemplo1.exe
.\exemplo1.exe

ghc -Wall Aplicacao.hs -o aplicacao.exe
.\aplicacao.exe
```

Sem gerar executável: `runghc Aplicacao.hs`.

No GHCi:

```
ghci Aplicacao.hs
ghci> executar "NNLLX" (0,0)
(2,2)
ghci> :t quadrante
```

Para o desafio investigativo, carregue `Experimentos.hs` no GHCi e compile com `-Wall` para ver os avisos de padrão incompleto e de equação redundante.

## Observações

- Os arquivos `.hs` não declaram `module`, conforme orientação do professor.
- Os arquivos gerados pela compilação (`.hi`, `.o`, executáveis) estão no `.gitignore`.
- Apenas o `Prelude` é usado.
