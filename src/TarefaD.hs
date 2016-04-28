{- | 
Module      : Main
Description : Módulo Haskell contendo funções para produzir os comandos, para que o robô termine o nivel com sucesso.
Copyright   : Ricardo António Gonçalves Pereira <a74185@alunos.uminho.pt>
              João Ismael Barros dos Reis <a75372@alunos.uminhho.pt  


Módulo Haskell para a Tarefa D.
-}

module Main where 

import Data.Char


{- | O tipo Nivel, representa uma String de Strings, ou seja, as linhas do mapa, e as coordenadas e comandos. -}
type Nivel       = [String]
{- | O tipo Mapa, representa uma String das Linhas do mapa do jogo.-}
type Mapa        = [Linha]
{- | O tipo Coordenadas, é dado por uma String.-}
type Coordenadas = String
{- | O tipo Comandos, é dado por uma String.-}
type Comandos    = String
{- | O tipo Resultado, é dado por uma String, representa o código completo, para apresentar a animação 3D do nível.-}
type Resultado   = String 
{- | O tipo Linha, respresenta uma linha do mapa, numa String. -}
type Linha       = String  
{- | O tipo Orientacao, representa a orientação do robo no mapa, que é dado num Char.-}
type Orientacao  = Char
{- | o tipo Posicao, respresenta o valor de x,y e a orientação num tuplo.-}
type Posicao     = (Int,Int,Char) 
{- | O tipo CoordLampada, representa a lista de Int das coordenadas de uma lâmpada.-}
type CoordLampada = [Int]


main = do inp <- getContents
          putStrLn (tarefa (lines inp))

testa f = do inp <- readFile f
             putStrLn (tarefa (lines inp))

{- | A função tarefa, recebe o Nivel do jogo, e fornece a função tarefa2, os dados referente ao Nivel, como a posição em tuplo e a lista de lista de Int, com 
as coordenadas das lâmpadas. 

== Exemplo de utilização :

>>>tarefa ["aaa","aAa","aaa","0 0 N"]  
"ADAL"
-}

tarefa :: Nivel -> Resultado
tarefa l = tarefa2 l (pos (last l)) (lamp)  
        where lamp  = localL (reverse(init l)) 0 0 

{- | A função tarefa2, recebe um Nivel, uma posição e uma lista de lista de Int, das coordendas das lâmpadas. Esta função respresenta o motor da tarefa E, devido ao facto de ser
a junção de todas as funções abaixo elaboradas. Esta função, aplica a função igualY , a função igualX, de forma a que o robô se deloca em L, para as lâmpadas. 
No entanto, caso nenhumas destas formas sejam possiveis, a tarefa muda a ordem da lista das lâmpadas a acenter. 
Por fim, como último caso, temos a função parede, para caso do aparecimento de obstáculos. 

== Exemplo de utilização :

>>>tarefa2 ["Aaa","aAa","aaa","0 0 N"] (0,0,'N') [[2,0]]
"ADALEAEAL"
-}

tarefa2 :: Nivel -> Posicao -> [CoordLampada] -> Comandos
tarefa2 l _ [] = []
tarefa2 l (a,b,c) (h:t)  | not(elem '1' igualarY) && not(elem '1' igualarDeX ) = init(igualarY) ++ init(igualarDeX) ++ "L" ++ tarefa2 l ((head h),(last h),last(igualarDeX)) t
                         | not(elem '1' igualarX) && not(elem '1' igualarDeY ) = init(igualarX) ++ init(igualarDeY) ++ "L" ++ tarefa2 l ((head h),(last h),last(igualarDeY)) t
                         | (elem '1' igualarY) && not(elem '1' igualarX) && not(elem '1' igualarDeY) = init(igualarX)++ init(igualarDeY) ++ "L" ++ tarefa2 l ((head h),(last h),last(igualarDeY)) t
                         | (elem '1' igualarX) && not(elem '1' igualarY) && not(elem '1' igualarDeX) = init(igualarY)++ init(igualarDeX) ++ "L" ++ tarefa2 l ((head h),(last h),last(igualarDeX)) t
                         | length (h:t) >= 2 = tarefa2 l (a,b,c) (troca (h:t))
                         | otherwise = parede l (a,b,c) (h:t) 
                where mapa = reverse(init l)
                      igualarY   = (igualY mapa (a,b,c) h)
                      igualarX   = (igualX mapa (a,b,c) h)
                      igualarDeX = (igualX mapa (a,(last h),(last (igualarY))) h)
                      igualarDeY = (igualY mapa ((head h),b,(last (igualarX))) h)  

{- | A função parede, recebe um Nivel, uma posição do robô e a lista de lista de Int, das coordenadas das lâmpadas. Esta função, permite ultrapassar obstáculos, ou seja, 
verificar se a próxima posição é válida para avançar ou nâo, devido ao obstáculos. Caso haja um obstáculo, a Norte do robô, a função desloca-o uma casa para Este e verifica
se o robô pode avançar, através da função tarefa2. Caso o obstáculo se encontra a Este, ele desloca-se uma casa para Norte, e verifica se pode avançar. Para as outras orientações, o robô, ajusta-se em 
função do Norte e do este. Concluindo esta função, perimite ao robô, desviar-se do osbtáculos presentes no Nível. 

== Exemplo de utilização :

>>>parede ["Aaa","caa","aaa","0 0 N"] (0,0,'N') [[2,0]]
"DAEAAEAL"
-}

parede :: Nivel -> Posicao -> [CoordLampada] -> Comandos
parede l (a,b,c) (h:t) | c == 'N' && not(elem '1' (avan mapa (a,b,c) (a,b,'E') (h:t))) = "D"++ avan mapa (a,b,c) (a,b,'E') (h:t) ++ "E" ++ tarefa2 l ((a+1),b,'N') (h:t)
                       | c == 'E' && not(elem '1' (avan mapa (a,b,c) (a,b,'N') (h:t))) = "E"++ avan mapa (a,b,c) (a,b,'N') (h:t) ++ "D" ++ tarefa2 l (a,(b+1),'E') (h:t)
                       | c == 'E' && not(elem '1' (avan mapa (a,b,c) (a,b,'E') (h:t))) = (avan mapa (a,b,c) (a,b,'E') (h:t)) ++ tarefa2 l (a+1,b,'E') (h:t)
                       | c == 'N' && not(elem '1' (avan mapa (a,b,c) (a,b,'N') (h:t))) = (avan mapa (a,b,c) (a,b,'N') (h:t)) ++ tarefa2 l (a,b+1,'N') (h:t) 
                       | c == 'O' && not(elem '1' (avan mapa (a,b,c) (a,b,'N') (h:t))) = "D" ++ tarefa2 l (a,b,'N') (h:t) 
                       | c == 'S' && not(elem '1' (avan mapa (a,b,c) (a,b,'E') (h:t))) = "E" ++ tarefa2 l (a,b,'E') (h:t) 
                       | c == 'S' && not(elem '1' (avan mapa (a,b,c) (a,b,'O') (h:t))) = "D" ++ tarefa2 l (a,b,'O') (h:t) 
                       | c == 'O' && not(elem '1' (avan mapa (a,b,c) (a,b,'S') (h:t))) = "E" ++ tarefa2 l (a,b,'S') (h:t)
      where  mapa = reverse(init l)
             igualarY   = (igualY mapa (a,b,c) h)
             igualarX   = (igualX mapa (a,b,c) h)

{- | A função avan, recebe um Mapa, duas posiçôes, sendo a primeira a inical e a segunda a seguinte, e a lista de lista de Int, das coordenadas das lâmpadas. A função tem como objectivo, validar, se o robô 
pode ou não avançar, e se caso pode avançar, verifica se anda ou salta. Caso nao possa avançar, devolve "1", para que seja detéctavél noutra função. 

== Exemplo de utilização :

>>>avan ["aaA","aAa","aaa"] (0,1,'N') (0,1,'N') [[1,1],[2,2]] 
"A"
-}

avan :: Mapa -> Posicao -> Posicao -> [CoordLampada] -> Comandos
avan l (a,b,c) (d,e,f) (h:t) | pI == pSe = "A"
                             | pI > pSe = "S"
                             | (succ pI) == pSe = "S"
                             | otherwise = "1"
             where pI = trans (posicao l a b) 
                   pSe = trans (posicaoSe l d e f)


{- | A função igualY, recebe um Mapa, uma Posicao do robô, e uma lista de Int, das coordenadas de uma lâmpada. Esta função compara o valor da cooordenada y da posição do robô
,com a coordenada y da lâmpada, e consoante for maior ou menor, vai aplicar alerações ao estado do robô, rodando para a esquerda ou para a direita, conforme a situação, ou caso seja 
possível, avança ou salta. A função tem em atenção orientar o robô, para Norte ou para Sul, para permitir que o robô possa avançar, tendo em conta a coordenada y, isto é, se
a coordenada y for maior do robô do que a da lâmpada, a função roda o robô para Sul, e caso seja o contrário, roda-o para Norte. É de destacar, que a função quando obtem o mesmo valor 
em y, devolve a orientação do robô, para que possa ser ultilizada por outra função. Caso nenhum dos parámetros sejam aceitaveis, a função devolve "1", uma forma de detéctar caso
seja a função aplicavél ou não. 

== Exemplo de utilização :

>>>igualY ["aaa","aAa","aaa"] (0,1,'N') [1,1]
"EAN"
-}

igualY :: Mapa -> Posicao -> CoordLampada -> Comandos
igualY l (a,b,c) (d:e:f)  | b < e && c == 'S' = "E" ++ igualY l (a,b,'E') (d:e:f)
                          | b < e && c == 'E' = "E" ++ igualY l (a,b,'N') (d:e:f)
                          | b < e && c == 'O' = "D" ++ igualY l (a,b,'N') (d:e:f)
                          | b > e && c == 'N' = "E" ++ igualY l (a,b,'O') (d:e:f)
                          | b > e && c == 'E' = "D" ++ igualY l (a,b,'S') (d:e:f)
                          | b > e && c == 'O' = "E" ++ igualY l (a,b,'S') (d:e:f)
                          | b > e && c == 'S' && pI == pSe        = "A" ++ igualY l (a,(b-1),'S') (d:e:f)
                          | b > e && c == 'S' && pI > pSe         = "S" ++ igualY l (a,(b-1),'S') (d:e:f)
                          | b > e && c == 'S' && (succ pI) == pSe = "S" ++ igualY l (a,(b-1),'S') (d:e:f)
                          | b < e && c == 'N' && pI == pSe        = "A" ++ igualY l (a,(b+1),'N') (d:e:f)
                          | b < e && c == 'N' && pI > pSe         = "S" ++ igualY l (a,(b+1),'N') (d:e:f)
                          | b < e && c == 'N' && (succ pI) == pSe = "S" ++ igualY l (a,(b+1),'N') (d:e:f)
                          | b == e = [c]
                          | otherwise = "1"
                 where pI = trans (posicao l a b) 
                       pSe = trans (posicaoSe l a b c) 

{- | A função igualX, em semelhança a função igualY, recebe um Mapa, uma Posicao do robô, e uma lista de Int, das coordenadas de uma lâmpada. Esta função atua de forma identica 
a função igualY, no entanto, difere a seu objectivo. Ao contrário da função igualY, esta funciona para a coordenada y, tentando orientar o robô, para Oeste caso a coordenada x do 
robô seja maior do que da lâmpada, ou para este, caso contrário.

== Exemplo de utilização :

>>>igualX ["aaa","aAa","aaa"] (0,0,'N') [1,1]
"DAE"
-}

igualX :: Mapa -> Posicao -> CoordLampada -> Comandos                                                   
igualX l (a,b,c) (d:e:f)   | a < d && c == 'S' = "E" ++ igualX l (a,b,'E') (d:e:f)
                           | a < d && c == 'N' = "D" ++ igualX l (a,b,'E') (d:e:f)
                           | a < d && c == 'O' = "E" ++ igualX l (a,b,'S') (d:e:f)
                           | a > d && c == 'E' = "E" ++ igualX l (a,b,'N') (d:e:f)
                           | a > d && c == 'S' = "D" ++ igualX l (a,b,'O') (d:e:f)
                           | a > d && c == 'N' = "E" ++ igualX l (a,b,'O') (d:e:f)
                           | a > d && c == 'O'&& pI == pSe        = "A" ++ igualX l ((a-1),b,'O') (d:e:f)
                           | a > d && c == 'O'&& pI > pSe         = "S" ++ igualX l ((a-1),b,'O') (d:e:f)
                           | a > d && c == 'O'&& (succ pI) == pSe = "S" ++ igualX l ((a-1),b,'O') (d:e:f)
                           | a < d && c == 'E'&& pI == pSe        = "A" ++ igualX l ((a+1),b,'E') (d:e:f)
                           | a < d && c == 'E'&& pI > pSe         = "S" ++ igualX l ((a+1),b,'E') (d:e:f)
                           | a < d && c == 'E'&& (succ pI) == pSe = "S" ++ igualX l ((a+1),b,'E') (d:e:f)
                           | a == d = [c]
                           | otherwise = "1"
                   where pI = trans (posicao l a b) 
                         pSe = trans (posicaoSe l a b c) 


{- | A função trans, recebe uma posição e tranforma, caso for um caratér entre 'A' e 'Z', em caractéres entre 'a' e 'z'. 
Esta função permite que os caractéres de 'A' até 'Z', sejam comparáveis com os caractéres de 'a' até 'z'. 

== Exemplo de utilização :

>>>trans 'A' 
'a'
-}

trans :: Char -> Char   
trans x = if ord x < 97  then chr ((ord x) + 32) else x 


{- | A função troca, recebe uma lista de listas de Int, que representam as coordenadas das lâmpadas. Desta forma, a função, passa a primeira lista, para o fim
da lista, o que permite na função principal, o robô, deslocar-se para outra lâmpada, caso a primeira da lista seja dificil de atingir. 
sejam comparáveis com os caractéres de 'a' até 'z'. 

== Exemplo de utilização :

>>>troca [[1,1],[2,2]] 
[[2,2],[1,1]]
-}

troca :: [CoordLampada] -> [CoordLampada]
troca (h:t) = t ++ [h]

{- | A função localL1 recebe uma Linha do Mapa, e devolve as coordenadas,numa lista de lista de Int, dos pontos que possuiem lâmpadas, isto é,
as posições que tem letras maiúsculas.

== Exemplo de utilização :

>>>localL1 "acbBba" 0 0
[[3,0]] 
-}

localL1 :: Linha -> Int -> Int -> [CoordLampada]
localL1 [] x y = []
localL1 (h:t) x y |isUpper h = [x,y]: localL1 t (x+1) y
                  |otherwise = localL1 t (x+1) y

{- | A função localL recebe uma Mapa, e devolve todas as coordenadas,numa lista de lista de Int, dos pontos que possuiem lâmpadas, isto é,
as posições que tem letras maiúsculas.

== Exemplo de utilização :

>>>localL ["acbBba","bbbAab"] 0 0
[[3,0],[3,1]] 
-}

localL :: Mapa -> Int -> Int -> [CoordLampada]
localL [] x y = []
localL (h:t) x y = (localL1 h x y) ++ (localL t x (y+1))

{- | A função robô, recebe uma String, nomeadamente, as Coordendas presente no Nivel, e passa para um tuplo, de forma a obter a coordenada x, em primeiro, 
a coordenada y, em segundo, e a orientação em último.

== Exemplo de utilização :

>>>pos "2 1 N" 
(2,1,'N')
-}

pos :: Coordenadas -> Posicao
pos l = let (a:b:c:d) = (words l)
        in (strInt a, strInt b, head c) 

{- | A função posicao, recebe o Mapa, e dois Int, que representam as coordenadas x e y. Esta função dá-nos o local exacto do robô no mapa, 
devolvendo assim o Char em que se localiza.

== Exemplo de utilização :

>>>posicao ["aBac","aAca","aabb","2 1 N","ASDAA"]
"c"

-}

posicao :: Mapa -> Int -> Int -> Char 
posicao [] x y = ' '
posicao l x y = head (drop x (head(drop y l)))


{- | A função posicaoSe, recebe o Mapa, dois Int, que representam as coordenadas x e y, e um Char, ou seja, a orientação do robô. 
Esta função dá-nos o local da posição seguinte, consoante a orientação do robô. Devolve assim o Char da próxima posição.

== Exemplo de utilização :

>>>posicao ["aBac","aAca","aabb","2 1 N","ASDAA"]
"a"

-}

posicaoSe :: Mapa -> Int -> Int -> Orientacao -> Char
posicaoSe l x y s | s == 'N' = posicao l x (y+1) 
                  | s == 'S' = posicao l x (y-1)
                  | s == 'E' = posicao l (x+1) y 
                  | s == 'O' = posicao l (x-1) y 

{- | A função strInt recebe uma String e converte em um Int correspodente, com 
recurso a função auxiliar converte. 

== Exemplo de utilização :

>>>strInt "123"
123
-}  

strInt :: String -> Int
strInt x = converte 0 (reverse (map digitToInt x))

{- | A função converte recebe um Int e uma lista de Int. Esta função passa a lista de Int, 
para o respectivo número, calculando-o, tendo em conta a base 10. O primeiro argumento, Int, 
serve como um acumulador para a base 10.

== Exemplo de utilização :

>>>converte 0 [1,2,3]
123
-}     

converte :: Int -> [Int]-> Int 
converte e (x:xs) = x*10^e + converte (e+1) xs
converte _ [] = 0

-- iuiug