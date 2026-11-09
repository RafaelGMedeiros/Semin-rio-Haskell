-- Experimentos.hs: material do desafio investigativo (carregar no GHCi)
--   ghci Experimentos.hs
-- Compile com -Wall e leia os avisos: eles sao parte da investigacao.

-- Experimento 1: mover sem a equacao curinga.
-- -Wall avisa "Pattern match(es) are non-exhaustive".
-- No GHCi: moverSemCuringa 'N' (0,0)  -> funciona
--          moverSemCuringa 'X' (0,0)  -> excecao em tempo de execucao
moverSemCuringa :: Char -> (Int, Int) -> (Int, Int)
moverSemCuringa 'N' (x, y) = (x, y + 1)
moverSemCuringa 'S' (x, y) = (x, y - 1)
moverSemCuringa 'L' (x, y) = (x + 1, y)
moverSemCuringa 'O' (x, y) = (x - 1, y)

-- Experimento 2: caso geral antes dos casos especificos.
-- -Wall avisa que a ultima equacao e redundante (nunca e alcancada).
-- No GHCi: quadranteInvertido (0,5)  -> "Q4", resposta errada (o certo e "eixo Y")
quadranteInvertido :: (Int, Int) -> String
quadranteInvertido (x, y)
  | x > 0 && y > 0 = "Q1"
  | x < 0 && y > 0 = "Q2"
  | x < 0 && y < 0 = "Q3"
  | otherwise      = "Q4"
quadranteInvertido (0, 0) = "origem"

main :: IO ()
main = putStrLn "Carregue este arquivo no GHCi (ghci Experimentos.hs) e teste as funcoes."
