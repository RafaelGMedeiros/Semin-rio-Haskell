<div align="center">

# 🤖 Robô Funcional

### Pattern matching em Haskell: um robô, quatro comandos e zero `if`

![Haskell](https://img.shields.io/badge/Haskell-5D4F85?style=for-the-badge&logo=haskell&logoColor=white)
![C](https://img.shields.io/badge/C-comparação-00599C?style=for-the-badge&logo=c&logoColor=white)
![CESAR School](https://img.shields.io/badge/CESAR%20School-2026.2-E4002B?style=for-the-badge)

**Seminário Técnico · Tema 05** · Programação Imperativa e Funcional · Prof. Roni Maciel

</div>

---

## 🎯 O projeto

Um robô vive em um plano cartesiano e recebe comandos como `"NNLLX"`: `N` (norte), `S` (sul), `L` (leste), `O` (oeste). Comandos desconhecidos não fazem nada. O projeto investiga **como o Haskell escolhe qual equação executar** e o que acontece quando nenhum padrão casa.

Cobre padrões literais, curinga `_`, tuplas `(x, y)`, listas `(c:cs)`, ordem das equações, avisos do `-Wall` e a comparação com o `switch` do C.

## 📁 Arquivos

| Arquivo | Conteúdo |
|---|---|
| `Exemplo1.hs` | Exemplo conceitual de pattern matching |
| `Aplicacao.hs` | `mover`, `executar`, `trajetoria`, `distanciaOrigem`, `quadrante` e a extensão (grade 10 x 10) |
| `Experimentos.hs` | Desafio investigativo: padrões incompletos e ordem das equações |
| `comparacao_switch.c` | O mesmo robô em C, com o problema do `break` esquecido |
| `SINTESE.md` | Descobertas e referências |

## 🎬 Exemplo

```text
ghci> executar "NNLLX" (0,0)
(2,2)

ghci> trajetoria "NL" (0,0)
[(0,0),(0,1),(1,1)]

ghci> quadrante (0,5)
"eixo Y"
```

## 🚀 Como executar

Requer GHC ([GHCup](https://www.haskell.org/ghcup/)) e, para o arquivo em C, o `gcc`. Apenas o `Prelude` é usado.

```bash
ghc -Wall Exemplo1.hs -o exemplo1 && ./exemplo1
ghc -Wall Aplicacao.hs -o aplicacao && ./aplicacao
gcc -Wall comparacao_switch.c -o comparacao && ./comparacao
```

No Windows, use `-o aplicacao.exe` e execute com `.\aplicacao.exe`. Sem gerar executável: `runghc Aplicacao.hs`. Para o desafio, abra `ghci Experimentos.hs`.

## 🔬 Principais descobertas

- **Sem o curinga**, o `-Wall` avisa `Pattern match(es) are non-exhaustive`, e `mover 'X' (0,0)` quebra só em tempo de execução.
- **A ordem importa:** com o caso geral primeiro, `quadrante (0,5)` devolve `"Q4"` em vez de `"eixo Y"`.
- **No C**, esquecer o `break` faz o `'N'` cair no `'S'` e o robô volta para `(0,0)`. No Haskell não existe *fall-through*.

## 👥 Equipe

**Rafael Gurgel · Lucas de Souza · Artur Holanda**

CESAR School · 2026.2
