<div align="center">

# 🤖 Robô Funcional

### Pattern matching em Haskell: um robô, duas linguagens de comando e zero `if`

**Seminário Técnico · Tema 05** · Programação Imperativa e Funcional · Prof. Roni Maciel

</div>

---

## 📖 Sobre o projeto

Este repositório reúne o trabalho do Tema 05 do seminário de programação funcional com Haskell: **pattern matching nos comandos de um robô**.

Um robô se move em um plano cartesiano. Sua posição é uma tupla `(x, y)` e ele recebe uma sequência de comandos em formato de texto, como `"NNLLX"` ou `"WWDDX"`. O robô entende **dois jeitos de escrever os comandos**, e eles podem ser misturados:

| Movimento | Bússola | Teclas de jogo | Efeito |
|:---:|:---:|:---:|:---:|
| Cima | `N` (norte) | `W` | `y + 1` |
| Baixo | `S` (sul) | `S` | `y - 1` |
| Direita | `L` (leste) | `D` | `x + 1` |
| Esquerda | `O` (oeste) | `A` | `x - 1` |
| Outro caractere | | | nada acontece |

As teclas de jogo funcionam em maiúscula e minúscula. No modo jogo, as **setas do teclado** também controlam o robô.

O problema é simples de propósito: ele deixa em evidência o mecanismo que o Haskell usa para decidir **qual equação de uma função executar**, sem `if` e sem `switch`.

## 🎯 Objetivos

- Entender como o Haskell seleciona a equação a ser usada: de cima para baixo, pela forma dos dados.
- Usar padrões **literais**, **curinga** (`_`), em **tuplas** `(x, y)` e em **listas** `(c:cs)`.
- Investigar o que acontece quando **nenhum padrão corresponde** à entrada e como o `-Wall` ajuda a perceber isso.
- Comparar o pattern matching com o `switch` do C, incluindo o problema do `break` esquecido.
- Explicar e demonstrar tudo isso ao vivo para a turma, com código escrito pela própria equipe.

## 🧩 O que foi implementado

| Função | Tipo | O que faz |
|---|---|---|
| `mover` | `Char -> (Int, Int) -> (Int, Int)` | Aplica um comando à posição |
| `executar` | `String -> (Int, Int) -> (Int, Int)` | Executa uma sequência e devolve a posição final |
| `trajetoria` | `String -> (Int, Int) -> [(Int, Int)]` | Lista todas as posições visitadas, incluindo a inicial |
| `distanciaOrigem` | `(Int, Int) -> Int` | Distância de Manhattan até a origem |
| `quadrante` | `(Int, Int) -> String` | Classifica a posição: origem, eixos ou `Q1` a `Q4` |
| `executarSeguro` | `String -> (Int, Int) -> (Int, Int)` | **Extensão:** o robô não sai de uma grade 10 × 10 |

O coração do projeto cabe em poucas linhas:

```haskell
mover :: Char -> (Int, Int) -> (Int, Int)
mover 'N' (x, y) = (x, y + 1)
mover 'W' (x, y) = (x, y + 1)
mover 'S' (x, y) = (x, y - 1)
mover 'L' (x, y) = (x + 1, y)
mover 'D' (x, y) = (x + 1, y)
mover 'O' (x, y) = (x - 1, y)
mover 'A' (x, y) = (x - 1, y)
mover _   pos    = pos          -- curinga: comando desconhecido não faz nada

executar :: String -> (Int, Int) -> (Int, Int)
executar []       pos = pos
executar (c : cs) pos = executar cs (mover c pos)
```

(No código do repositório, `mover` também tem as equações para as teclas `w`, `s`, `d` e `a` em minúscula.)

Sem laço, sem `if` e sem variável mudando de valor: cada passo produz uma nova posição.

## 🎮 Modo teclado

Ao executar o `Aplicacao.hs`, um menu permite **jogar com o robô como em um jogo**: `W A S D` ou as **setas** movem o robô em uma grade 10 × 10, sem apertar Enter, e `Q` sai.

```text
. . . . . . . . . .
. . . . . . . . . .
. . . @ . . . . . .
. . . . . . . . . .
Posicao: (3,7)  |  Q1
```

A tecla pressionada já é o comando do robô, e o jogo reaproveita `moverSeguro`, então o robô para na borda da grade.

## 🎬 Exemplo de uso

```text
ghci> executar "NNLLX" (0,0)
(2,2)

ghci> executar "WWDDX" (0,0)
(2,2)

ghci> trajetoria "NL" (0,0)
[(0,0),(0,1),(1,1)]

ghci> distanciaOrigem (-3,4)
7

ghci> quadrante (0,5)
"eixo Y"

ghci> executarSeguro "NNNNNNNNNNNN" (0,0)
(0,9)
```

## 📁 Estrutura

| Arquivo | Conteúdo |
|---|---|
| `Exemplo1.hs` | Exemplo conceitual: o pattern matching isolado |
| `Aplicacao.hs` | As cinco funções, a extensão, a demonstração e o modo teclado |
| `Experimentos.hs` | Desafio investigativo: padrões incompletos e ordem das equações |
| `comparacao_switch.c` | O mesmo robô em C, com `switch` |
| `SINTESE.md` | Descobertas, evidências e referências |

## 🚀 Como executar

Requer o GHC ([GHCup](https://www.haskell.org/ghcup/)) e, para o arquivo em C, o `gcc`.

```bash
ghc -Wall Exemplo1.hs -o exemplo1 && ./exemplo1
ghc -Wall Aplicacao.hs -o aplicacao && ./aplicacao
gcc -Wall comparacao_switch.c -o comparacao && ./comparacao
```

No `aplicacao`, escolha **1** para a demonstração das funções ou **2** para jogar. No Windows, use `-o aplicacao.exe` e execute com `.\aplicacao.exe`. Para rodar sem gerar executável: `runghc Aplicacao.hs`. Para o desafio investigativo, abra `ghci Experimentos.hs`.

> As setas funcionam em terminais Linux e macOS. No Windows, prefira `W A S D`.

## 🔬 Principais descobertas

1. **Sem o curinga, o programa quebra em tempo de execução.** O `-Wall` avisa `Pattern match(es) are non-exhaustive`, mas `moverSemCuringa 'X' (0,0)` só falha quando é executado.
2. **A ordem das equações importa.** Com o caso geral escrito primeiro, `quadrante (0,5)` devolve `"Q4"` em vez de `"eixo Y"`, e o compilador avisa que uma equação ficou inalcançável.
3. **O `switch` do C tem uma armadilha que o Haskell não tem.** Esquecer o `break` faz o `'N'` cair no `'S'` e o robô volta para `(0,0)`. No Haskell cada equação é independente, não existe *fall-through*.

| | Haskell | C |
|---|---|---|
| Escolha do caso | De cima para baixo, pela forma do dado | Pelo valor, com saltos entre casos |
| Caso esquecido | Aviso do compilador com `-Wall` | Silencioso |
| Estado | Cada passo gera um valor novo | Variável alterada no lugar |

## 💡 Por que isso importa

Pattern matching deixa o código mais **declarativo**: em vez de dizer como testar cada situação, descrevemos a forma dos dados e o resultado esperado. Isso reduz erros, facilita a leitura e permite que o compilador avise quando esquecemos um caso.

## 👥 Equipe

**Integrantes:** Rafael Gurgel de Amorim Medeiros · Artur Holanda Costa · Lucas de Souza

CESAR School · Programação Imperativa e Funcional · 2026.2

## 📚 Referências

- [Documentação oficial do Haskell](https://www.haskell.org/documentation/)
- [Módulo Prelude](https://hackage.haskell.org/package/base/docs/Prelude.html)
- LIPOVAČA, M. *Learn You a Haskell for Great Good!* No Starch Press, 2011.
