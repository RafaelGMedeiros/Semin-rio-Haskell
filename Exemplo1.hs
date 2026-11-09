-- Exemplo1.hs: exemplo conceitual de pattern matching
-- Isola o conceito: o Haskell escolhe a equacao de cima para baixo,
-- usando a forma dos dados de entrada.

-- 1. Padroes literais e curinga (_)
descreverComando :: Char -> String
descreverComando 'N' = "norte"
descreverComando 'S' = "sul"
descreverComando 'L' = "leste"
descreverComando 'O' = "oeste"
descreverComando _   = "comando desconhecido"

-- 2. Padrao em tupla: extrai os campos direto na definicao
somaPar :: (Int, Int) -> Int
somaPar (a, b) = a + b

-- 3. Padroes em lista: vazia, um elemento, ou cabeca e cauda
descreverLista :: [Int] -> String
descreverLista []      = "lista vazia"
descreverLista [_]     = "um elemento"
descreverLista (x : _) = "mais de um elemento, comecando em " ++ show x

-- 4. A ordem das equacoes importa: a primeira que casar vence
ehZero :: Int -> String
ehZero 0 = "zero"
ehZero _ = "diferente de zero"

main :: IO ()
main = do
  putStrLn "--- Padroes literais e curinga ---"
  putStrLn (descreverComando 'N')
  putStrLn (descreverComando 'X')
  putStrLn "--- Padrao em tupla ---"
  print (somaPar (3, 4))
  putStrLn "--- Padroes em lista ---"
  putStrLn (descreverLista [])
  putStrLn (descreverLista [7])
  putStrLn (descreverLista [7, 8, 9])
  putStrLn "--- Ordem das equacoes ---"
  putStrLn (ehZero 0)
  putStrLn (ehZero 5)
