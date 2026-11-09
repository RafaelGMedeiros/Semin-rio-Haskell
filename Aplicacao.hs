-- Aplicacao.hs: controle de um robo em um plano cartesiano
-- Posicao: tupla (x, y). O robo entende dois jeitos de escrever comandos:
--   letras de bussola: 'N' (norte), 'S' (sul), 'L' (leste), 'O' (oeste)
--   teclas de jogo:    'W' (cima), 'S' (baixo), 'D' (direita), 'A' (esquerda)
-- Os dois jeitos podem ser misturados. O 'S' vale para os dois (sul = baixo).
-- As teclas de jogo tambem funcionam em minuscula.
--
-- As funcoes obrigatorias e a extensao sao puras (sem IO).
-- Somente a parte final (demonstracao e modo teclado) usa entrada e saida.

import System.IO

-- 1. Aplica um comando a posicao; comandos desconhecidos mantem a posicao.
mover :: Char -> (Int, Int) -> (Int, Int)
mover 'N' (x, y) = (x, y + 1)
mover 'W' (x, y) = (x, y + 1)
mover 'w' (x, y) = (x, y + 1)
mover 'S' (x, y) = (x, y - 1)
mover 's' (x, y) = (x, y - 1)
mover 'L' (x, y) = (x + 1, y)
mover 'D' (x, y) = (x + 1, y)
mover 'd' (x, y) = (x + 1, y)
mover 'O' (x, y) = (x - 1, y)
mover 'A' (x, y) = (x - 1, y)
mover 'a' (x, y) = (x - 1, y)
mover _   pos    = pos

-- 2. Executa uma sequencia de comandos e devolve a posicao final.
executar :: String -> (Int, Int) -> (Int, Int)
executar []       pos = pos
executar (c : cs) pos = executar cs (mover c pos)

-- 3. Todas as posicoes visitadas, incluindo a inicial.
--    Comando desconhecido nao move o robo, entao a posicao se repete.
trajetoria :: String -> (Int, Int) -> [(Int, Int)]
trajetoria []       pos = [pos]
trajetoria (c : cs) pos = pos : trajetoria cs (mover c pos)

-- 4. Distancia de Manhattan ate a origem: |x| + |y|.
distanciaOrigem :: (Int, Int) -> Int
distanciaOrigem (x, y) = abs x + abs y

-- 5. Classifica a posicao. Eixos e origem por padroes literais;
--    o sinal das coordenadas por guardas (sem if).
quadrante :: (Int, Int) -> String
quadrante (0, 0) = "origem"
quadrante (_, 0) = "eixo X"
quadrante (0, _) = "eixo Y"
quadrante (x, y)
  | x > 0 && y > 0 = "Q1"
  | x < 0 && y > 0 = "Q2"
  | x < 0 && y < 0 = "Q3"
  | otherwise      = "Q4"

-- Extensao: o robo nao sai de uma grade 10 x 10 (coordenadas de 0 a 9).
-- Se o movimento sairia da grade, o robo fica parado.
dentroDaGrade :: (Int, Int) -> Bool
dentroDaGrade (x, y) = x >= 0 && x <= 9 && y >= 0 && y <= 9

moverSeguro :: Char -> (Int, Int) -> (Int, Int)
moverSeguro c pos
  | dentroDaGrade novo = novo
  | otherwise          = pos
  where
    novo = mover c pos

executarSeguro :: String -> (Int, Int) -> (Int, Int)
executarSeguro []       pos = pos
executarSeguro (c : cs) pos = executarSeguro cs (moverSeguro c pos)

-- ---------------------------------------------------------------
-- Modo teclado: W A S D ou setas controlam o robo, como em um jogo.
-- A tecla pressionada ja e o proprio comando do robo.
-- (As letras N, S, L e O tambem funcionam aqui.)
-- ---------------------------------------------------------------

-- Ultimo caractere de uma seta (ESC [ A/B/C/D) -> comando equivalente.
setaParaComando :: Char -> Char
setaParaComando 'A' = 'W'   -- seta para cima
setaParaComando 'B' = 'S'   -- seta para baixo
setaParaComando 'C' = 'D'   -- seta para a direita
setaParaComando 'D' = 'A'   -- seta para a esquerda
setaParaComando _   = '?'

-- Le uma tecla; setas chegam como sequencia ESC [ X em terminais Linux/macOS.
lerTecla :: IO Char
lerTecla = do
  c <- getChar
  if c == '\ESC' then lerSeta else return c

lerSeta :: IO Char
lerSeta = do
  pronto <- hReady stdin
  if not pronto
    then return '\ESC'
    else do
      _ <- getChar
      d <- getChar
      return (setaParaComando d)

-- Grade 10 x 10 com o robo (@). A linha y = 9 aparece no topo.
desenhar :: (Int, Int) -> String
desenhar pos = unlines [linha y | y <- [9, 8 .. 0]]
  where
    linha y = unwords [[celula (x, y)] | x <- [0 .. 9]]
    celula p
      | p == pos  = '@'
      | otherwise = '.'

jogar :: (Int, Int) -> IO ()
jogar pos = do
  putStrLn ""
  putStr (desenhar pos)
  putStrLn ("Posicao: " ++ show pos ++ "  |  " ++ quadrante pos)
  fim <- isEOF
  if fim
    then putStrLn "Fim da entrada."
    else do
      tecla <- lerTecla
      if tecla == 'q' || tecla == 'Q'
        then putStrLn "Ate a proxima!"
        else jogar (moverSeguro tecla pos)

-- Demonstracao das funcoes com entradas e saidas fixas.
demonstracao :: IO ()
demonstracao = do
  putStrLn "--- mover ---"
  print (mover 'N' (0, 0))
  print (mover 'W' (0, 0))
  print (mover 'X' (2, 3))
  putStrLn "--- executar ---"
  print (executar "NNLLX" (0, 0))
  print (executar "WWDDX" (0, 0))
  print (executar "" (5, 5))
  putStrLn "--- trajetoria ---"
  print (trajetoria "NL" (0, 0))
  print (trajetoria "WD" (0, 0))
  print (trajetoria "" (1, 1))
  putStrLn "--- distanciaOrigem ---"
  print (distanciaOrigem (-3, 4))
  print (distanciaOrigem (0, 0))
  putStrLn "--- quadrante ---"
  print (quadrante (0, 5))
  print (quadrante (3, 0))
  print (quadrante (0, 0))
  print (quadrante (2, 2))
  print (quadrante (-2, 2))
  print (quadrante (-2, -2))
  print (quadrante (2, -2))
  putStrLn "--- extensao: grade 10 x 10 ---"
  print (executarSeguro "SSSOOO" (1, 1))
  print (executarSeguro "NNNNNNNNNNNN" (0, 0))

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  hSetBuffering stdin NoBuffering
  hSetEcho stdin False
  putStrLn "Robo funcional"
  putStrLn "  1 - Demonstracao das funcoes"
  putStrLn "  2 - Jogar (W A S D ou setas; Q sai)"
  putStr "Escolha: "
  opcao <- getChar
  putStrLn [opcao]
  case opcao of
    '1' -> demonstracao
    '2' -> jogar (0, 0)
    _   -> putStrLn "Opcao invalida."
  hSetEcho stdin True
