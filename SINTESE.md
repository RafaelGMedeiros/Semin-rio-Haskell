# SÍNTESE DAS DESCOBERTAS

**Tema:** 05 - Pattern matching nos comandos de um robô

**Integrantes:** Rafael Gurgel de Amorim Medeiros, Artur Holanda Costa, Lucas de Souza

## 1. O conceito em poucas palavras

Pattern matching é definir uma função por casos, descrevendo a forma dos dados de entrada: um valor literal (`'N'`, `0`), uma tupla (`(x, y)`), uma lista vazia (`[]`) ou não vazia (`(c:cs)`). O Haskell testa as equações de cima para baixo e executa a primeira que casa. O curinga `_` casa com qualquer valor e funciona como o caso "caso contrário".

No projeto, um robô se move em um plano cartesiano. A posição é uma tupla `(x, y)`, e `mover`, `executar` e `trajetoria` usam padrões literais, o curinga e `(c:cs)`. Nenhuma variável é alterada: cada comando devolve uma nova posição, o que liga o tema às funções puras e à imutabilidade vistas nas Aulas 10 e 11.

## 2. Resposta ao desafio investigativo

Ambiente: GHC [versão: rodar `ghc --version`]. Os experimentos estão em `Experimentos.hs`.

**Pergunta 1: o que acontece ao remover a equação curinga de `mover` e executar `mover 'X' (0,0)`?**

Compilando com `ghc -Wall Experimentos.hs`, o compilador emite:

```text
warning: [-Wincomplete-patterns]
    Pattern match(es) are non-exhaustive
    In an equation for `moverSemCuringa':
        Patterns of type `Char', `(Int, Int)' not matched:
            p _ where p is not one of {'O', 'L', 'N', ...}
```

No GHCi:

```text
ghci> moverSemCuringa 'N' (0,0)
(0,1)
ghci> moverSemCuringa 'X' (0,0)
*** Exception: Experimentos.hs:(10,1)-(13,39): Non-exhaustive patterns in function moverSemCuringa
```

Conclusão: o programa compila mesmo com o padrão incompleto, e a falha só aparece em tempo de execução, quando chega um comando que nenhuma equação cobre. O único aviso é o do `-Wall`.

**Pergunta 2: o que muda ao colocar o caso geral de `quadrante` primeiro?**

Em `quadranteInvertido`, as guardas com `otherwise` vêm antes dos casos de origem e eixos. O `-Wall` avisa:

```text
warning: [-Woverlapping-patterns]
    Pattern match is redundant
    In an equation for `quadranteInvertido':
        quadranteInvertido (0, 0) = ...
```

Resultado:

```text
ghci> quadrante (0,5)
"eixo Y"
ghci> quadranteInvertido (0,5)
"Q4"
```

Conclusão: a ordem das equações é parte do significado da função. A primeira equação, com `otherwise`, aceita qualquer entrada, então as equações seguintes nunca são alcançadas e `(0,5)` é classificado errado como `"Q4"`.

**Pergunta 3: como isso se compara ao `switch` do C, incluindo o `break` esquecido?**

Em `comparacao_switch.c`, esquecer o `break` do caso `'N'` faz a execução continuar no caso `'S'`:

```text
mover 'N' (0,0)        -> (0,1)
moverComBug 'N' (0,0)  -> (0,0)
```

O robô anda para o norte e volta para o sul. Compilando com `gcc -Wall`, não houve nenhum aviso. Em Haskell cada equação é independente, então esse erro não existe.

## 3. Principais descobertas

1. **Padrão incompleto compila.** O erro só aparece em execução, e o `-Wall` é a única proteção (evidência: pergunta 1).
2. **A ordem das equações muda o resultado.** O compilador percebe o caso inalcançável com `-Woverlapping-patterns` (pergunta 2).
3. **Não existe *fall-through* em Haskell.** No `switch` do C, um `break` esquecido altera o comportamento sem aviso com `-Wall` (pergunta 3).
4. **Padrões casam a forma, e guardas testam condições.** Em `quadrante`, usamos padrões literais para a origem e os eixos, e guardas (`x > 0 && y > 0`) para os quadrantes, porque um padrão não consegue testar "maior que zero".
5. **A recursão sobre listas é pattern matching.** `executar` e `trajetoria` usam `[]` como caso base e `(c:cs)` como passo, sem laço e sem variável de controle.

## 4. Comparação com a abordagem imperativa

| | Haskell (pattern matching) | C (`switch`) |
|---|---|---|
| Escolha do caso | De cima para baixo, pela forma do dado | Pelo valor, com saltos entre casos |
| Caso esquecido | Aviso do `-Wall` e erro em execução | Sem `default`, o comando é ignorado em silêncio |
| `break` esquecido | Não existe | *Fall-through*: o código continua no caso seguinte |
| Estado | Cada passo devolve uma nova posição | A posição é alterada no lugar |
| Percorrer comandos | Recursão com `(c:cs)` | Laço `for` com índice |

## 5. Dificuldades e limitações

[Ajustem com o que a equipe realmente viveu. Pontos técnicos que apareceram no projeto:]

- Padrões não testam condições como `x > 0`, o que obrigou a combinar padrões e guardas em `quadrante`.
- Um padrão incompleto não impede a compilação: o aviso só aparece com `-Wall`, e o erro vem em execução.
- O modo jogo precisa ler teclas sem Enter e reconhecer setas, que chegam como a sequência `ESC [ X` em terminais Linux e macOS. No Windows isso pode não funcionar, e por isso `W A S D` é o caminho mais seguro.
- O modo jogo usa `System.IO`, que não é o Prelude. [Registrar aqui a resposta do professor sobre o uso desse módulo.]
- As teclas `W A S D` foram adicionadas além dos comandos `N S L O` do enunciado, e o `S` serve para os dois (sul e baixo).

## 6. Quadro de contribuições

| Integrante | Funções implementadas | Pesquisa | Parte da apresentação |
|---|---|---|---|
| Rafael Gurgel de Amorim Medeiros | [preencher] | [preencher] | [preencher] |
| [nome completo] | [preencher] | [preencher] | [preencher] |
| [nome completo] | [preencher] | [preencher] | [preencher] |

## 7. Referências

- HASKELL.ORG. *Documentation*. Disponível em: https://www.haskell.org/documentation/.
- HASKELL. *Documentação do módulo Prelude*. Disponível em: https://hackage.haskell.org/package/base/docs/Prelude.html.
- GHC. *GHC User's Guide* (avisos `-Wincomplete-patterns` e `-Woverlapping-patterns`). Disponível em: https://downloads.haskell.org/ghc/latest/docs/users_guide/.
- LIPOVAČA, M. *Learn You a Haskell for Great Good!* San Francisco: No Starch Press, 2011.
- Ferramentas de apoio: [citar, por exemplo, "Claude (Anthropic), usado para apoio na estrutura do código e da documentação; todos os integrantes revisaram e conseguem explicar e alterar o código"].
