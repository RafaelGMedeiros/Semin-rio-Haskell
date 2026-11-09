-- Aplicacao.hs: controle de um robo em um plano cartesiano
-- Posicao: tupla (x, y). Comandos: 'N' (norte), 'S' (sul), 'L' (leste), 'O' (oeste).

-- 1. Aplica um comando a posicao; comandos desconhecidos mantem a posicao.
mover :: Char -> (Int, Int) -> (Int, Int)
mover 'N' (x, y) = (x, y + 1)
mover 'S' (x, y) = (x, y - 1)
mover 'L' (x, y) = (x + 1, y)
mover 'O' (x, y) = (x - 1, y)
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

main :: IO ()
main = do
  putStrLn "--- mover ---"
  print (mover 'N' (0, 0))
  print (mover 'X' (2, 3))
  putStrLn "--- executar ---"
  print (executar "NNLLX" (0, 0))
  print (executar "" (5, 5))
  putStrLn "--- trajetoria ---"
  print (trajetoria "NL" (0, 0))
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
