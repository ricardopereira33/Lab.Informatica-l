{- | 
Module      : Main
Description : Módulo Haskell contendo funções para validar um nivel do jogo.
Copyright   : Ricardo António Gonçalves Pereira <a74185@alunos.uminho.pt>
              João Ismael Barros dos Reis <a75372@alunos.uminhho.pt  


Módulo Haskell para a Tarefa A.
-}
module Main where

import Data.Char


main = do inp <- getContents
          putStrLn (tarefa (lines inp))


testa f = do inp <- readFile f
             putStrLn (tarefa (lines inp))

{- | A função tarefa, é a função principal, que recebe o Nivel, e verifica, se este é válido ou não, ultilizando
várias funções auxiliares. O resulatdo baseia-se em dar o número da linha, onde ocorre o erro, numa String, caso o nivel apresentar erros: 
Caso estiver certo, devolve uma String OK. 

== Exemplos de utilização :

>>>tarefa ["aaabba","bbbaab","1 1 N","ASDE"]
"OK"

>>>tarefa ["aaabba","bcefd","1 1 N","ASDE"]
"2"
-}
tarefa :: Nivel -> Resultado
tarefa l = if limite l == False
           then "1"
           else if solucao (last (doisUlt l)) == False 
                then show (length l)
                else if coordenadas (head (doisUlt l)) == False || coordenadasY l (yponto l) == False || coordenadasX l (xponto l) == False 
                     then show (length (init l))
                     else if length (mapa l) >= erro1 (mapa l) 
                          then show (erro1 (mapa l))
                          else if length (mapa l) >= erro2 (comp (mapa l)) (mapa l)  
                               then show (erro2 (comp (mapa l)) (mapa l))
                               else if nulas l 
                                    then show (erroN l)
                                    else "OK" 


{- | O tipo Nivel, representa uma String de Strings, ou seja, as linhas do mapa, e as coordenadas e comandos. -}
type Nivel       = [String]
{- | O tipo Mapa, representa uma String das Linhas do mapa do jogo.-}
type Mapa        = [Linha]
{- | O tipo Coordenadas, é dado por uma String.-}
type Coordenadas = String
{- | O tipo Comandos, é dado por uma String.-}
type Comandos    = String
{- | O tipo Resultado, é dado por uma String.-}
type Resultado   = String 
{- | O tipo Linha, respresenta uma linha do mapa, numa String. -}
type Linha       = String  
{- | O tipo Orientacao, representa a orientação do robo no mapa, que é dado num Char.-}
type Orientacao  = Char
{- | o tipo Vx, respresenta o valor de x, das Coordenadas.-}
type Vx = String
{- | o tipo Vy, respresenta o valor de y, das Coordenadas.-}
type Vy = String
{- | O tipo CoordComandos, é dado por uma lista de String, contendo as Coordenadas e os Comandos.-}
type CoordComandos =  [String]


{- | A função mapa, é uma funçao que recebe a lista completa do nivel, 
e retira os dois ultimos elementos, ou seja, as coordenadas e os comandos. 

== Exemplo de utilização :

>>>mapa ["aaabba","bbbaab","1 2 N","ASDE"]
["aaabba",bbbaab"] -} 

mapa :: Nivel -> Mapa 
mapa [] = []
mapa l = init ( init l)   


{- | A função erro1 é uma função que vai receber uma lista das linhas que a constituem o mapa.
O seu obejctivo é analisar cada lista para averiguar se são linhas válidas para o mapa, isto é, se todas as 
linhas sao constituidas por letras. Caso o mapa estiver completamente correcto, o resultado é o número de linhas +1, 
para diferenciar, caso houver erro na ultima linha. 

== Exemplo de utilização :

>>>erro1 ["aaabba","bbba2b"]
2 -}

erro1 :: Mapa -> Int
erro1 [] = 1
erro1 (h:t) = if letras1 h 
              then 1 + erro1 t
              else 1

{- | A função letras1 recebe a lista para uma linha do mapa, e verifica se é toda
constituida por caracteres do alfabeto. 

== Exemplos de utilização :

>>>letras1 "aabbba"
True 

>>>letras1 "aacb2a"
False
-}


letras1 :: Linha -> Bool
letras1 [] = True 
letras1 (h:t) = if isAlpha h 
                then letras1 t
                else False 


{- | A função erro2 recebe um Int, ou seja, o comprimento váildo, para as linhas do mapa, e a String do Mapa, 
para comparar se todas as linhas do mapa, têm o comprimento válido. 

== Exemplo de utilização :

>>>erro2 5 ["aaaaa","aaaa","aaaaa"]
2
-}

erro2 :: Int -> Mapa -> Int 
erro2 x [] = 1
erro2 x (h:t) = if length h == x 
                then 1 + erro2 x t
                else if x == 0 
                     then 2 
                     else 1

 
{- | A função limite recebe a lista do nivel completo, e verifica se este é constituido pelo numero minimo de linhas, ou seja,
3 linhas, uma para o mapa, uma para as coordenadas e uma para os comandos. 

== Exemplos de utilização :

>>>limite ["aaaa","0 1 N","ASDE"]
True

>>>limite ["aaa","ASDE"]
False
-}

limite :: Nivel -> Bool
limite l = if length l >= 3 then True 
       else False 


{- | A função comprimento compara o comprimento das listas que correspondem as linhas do mapa, para 
verificar se o número de colunas seja igual para todas as linhas. Com isto, o método usado na 
função, é retirar da lista, todas as listas que tiverem comprimento igual.

== Exemplo de utilização :

>>>comprimento ["aaaa","aaa","aaaa"]
["aaaa","aaaa"]

-}


comprimento :: Mapa -> [String]
comprimento (h:t) = filter (\x-> length x ==length h) t


{- | A função comp reitra da lista, o comprimento, das listas constiuidas pela String.
Esta função, será ultilizada como amostra do comprimento válido, para a função erro2.

== Exemplo de utilização :

>>>comp ["aaaa","aaaa","aaaa"]
4
 -}

comp :: [String] -> Int 
comp [] = 2 
comp l = length (ultimo (comprimento l))

{- | A função ultimo, é uma função auxiliar, que desepenha a mesma função que a função last. 
Contudo, a função ultimo está programada em caso receber uma lista vazia.

== Exemplos de utilização :

>>>ultimo ["aaaa","aaaa","aaaa"]
"aaaa"

>>>ultimo []
""
 -}

ultimo :: [String] -> String 
ultimo [] = ""
ultimo t = last t 

{- | A função doisUlt recebe  a String do Nivel, e retira o mapa, dando a lista das coordenadas e dos comandos.

== Exemplo de utilização :

>>>doisUlt ["aaaa","aaaa","aaaa","0 1 N","ASDAA"]
["0 1 N","ASDAA"]
 -}

doisUlt :: Nivel -> CoordComandos
doisUlt [] = []
doisUlt l = if length l <= 2 then l 
	        else drop ((length l) - 2) l


{- | A função solucao recebe a String dos Comandos, e verifica, se os Comandos são constituidos 
apenas pelos comandos válidos, isto é, A,E,S,D e L.

== Exemplos de utilização :

>>>solucao "ASDAA"
True

>>>solucao "ASDFS"
False 
 -}


solucao :: Comandos -> Bool
solucao [] = True
solucao (h:t) = if (h == 'A') || (h == 'E') || (h == 'S') || (h == 'D') || (h == 'L')
	            then solucao t
	            else False


{- | A função coordenadas recebe a String das Coordenadas, e verifica, se as Coordenadas estão bem defenidas, 
tendo como funções auxiliares as funções coordenadas1 e coordenadas2.

== Exemplos de utilização :

>>>coordenadas "0 1 N"
True

>>>solucao "0 S N"
False 
 -}



coordenadas :: Coordenadas -> Bool 
coordenadas l = if null l == True 
                then False
                else if coordenadas1 (init l) == False 
                     then False 
                     else if coordenadas2 (last l) == False 
                          then False 
                          else if last(init l) == ' '
                               then True
                               else False 


{- | A função coordenadas1 recebe a String das Coordenadas, e verifica apenas a parte referente a posição no mapa, isto é,   
as coordenadas x e y, e respectivos espaços existentes entre eles e também da letra que indica a orientação do robô.

== Exemplos de utilização :

>>>coordenadas1 "0 1 "
True

>>>solucao1 "0 S "
False 
 -}


coordenadas1 :: Coordenadas -> Bool
coordenadas1 [] = True
coordenadas1 (x:[]) = True 
coordenadas1 (h:t:x) = if isDigit1 h && (isvazio t || isDigit1 t) 
                       then coordenadas1 x 
	                     else if isvazio h && isDigit t 
                            then True
                            else False


{- | A função coordenadas2 recebe a String das Coordenadas, e fica responsável por averiguar a letra que mostra a orientação do robô. 
Com isto, as orientções apenas podem ser N,S,O e E.

== Exemplos de utilização :

>>>coordenadas2 "N"
True

>>>solucao2 "2"
False 
 -}


coordenadas2 :: Orientacao -> Bool
coordenadas2 x = x == 'N' || x == 'S' || x == 'O' || x == 'E'


{- | A função coordenadasX recebe a String do Nivel, e um Int, que servirá de indicador do limite máximo de x, 
pois o valor de x não pode exeder o número de colunas do tabuleiro. 

== Exemplos de utilização :

>>>coordenadasX ["aaaa","aaaa","aaaa","0 1 N","ASDAA"] 2
True 

>>>coordenadasX ["aaca","abba","adaa","0 1 N","ASDAA"] 4
False 
 -}



coordenadasX :: Nivel -> Int -> Bool
coordenadasX w x = if length (head w)>x && x>=0 
                   then True
                   else False 


{- | A função coordenadasY recebe a String do Mapa, e um Int, e tal como a função coordenadasX, servirá de 
indicador do limite máximo de y, pois o valor de y não pode exeder o número de linhas do mapa. 

== Exemplos de utilização :

>>>coordenadasY ["aAB","aaa","acd","0 1 N","ASDAA"] 2
True 

>>>coordenadasY ["aaca","abba","adaa","0 1 N","ASDAA"] 3
False 
 -}


coordenadasY :: Nivel -> Int -> Bool
coordenadasY w y = if length (init (init w))>y && y>=0 
                   then True 
                   else False

{- | A função strInt recebe uma String e converte em um Int correspodente, com 
recurso a função auxiliar converte. 

== Exemplo de utilização :

>>>strInt "123"
123
-}               


strInt :: String -> Int
strInt x = converte 0 (reverse (map digitToInt x))

{- | A função converte recebe um Int e uma lista de Int. Esta função passa a lista de Int, 
para o respectivo numero, calculando-o, tendo em conta a base 10. O primeiro argumento, Int, 
serve como um acumulador para a base 10.


== Exemplo de utilização :

>>>converte 0 [1,2,3]
123
-}               


converte :: Int -> [Int]-> Int 
converte e (x:xs) = x*10^e + converte (e+1) xs
converte _ [] = 0 

{- | A função isDigit1 verifica se um caracter é um número.

== Exemplos de utilização :

>>>isDigit1 '2'
True 

>>>isDigit1 'a'
False
-}    
isDigit1 :: Char -> Bool 
isDigit1 x = ord x >= 48 && ord x <= 57

{- | A função isvazio1 verifica se um caracter é o elemento vazio.

== Exemplos de utilização :

>>>isvazio1 ' '
True 

>>>isvazio1 'a'
False
-}    

isvazio :: Char -> Bool
isvazio l = if l == ' ' then True 
	        else False


{- | A função yponto recebe a String do Nível, e calcula a coordenada Y.

== Exemplo de utilização :

>>>yponto  ["aaca","abba","adaa","0 1 N","ASDAA"] 
1
-}  

yponto :: Nivel -> Int
yponto l = strInt(ajuda5 (head(doisUlt l)))

{- | A função ajuda3 recebe uma String, e devolve os primeiros algarismos que encontrar. Esta função auxiliar tem como objectivo, retirar 
das Coordenadas, o valor de X.

== Exemplo de utilização :

>>>ajuda3  "0 1 N"
"0"
-}

ajuda3 :: Coordenadas -> Vx 
ajuda3 [] = [] 
ajuda3 (h:t) = if isNumber h  
               then h: ajuda3 t
               else []

{- | A função ajuda5 recebe uma String, e retira os primeiros algarismos que encontrar, e devolve os próximos algarismos. Esta função auxiliar tem como objectivo, retirar 
das Coordenadas, o valor de Y.

== Exemplo de utilização :

>>>ajuda5  "0 1 N"
"1"
-}

ajuda5 :: Coordenadas -> Vy
ajuda5 [] = []
ajuda5 (h:t) = if isNumber h 
               then ajuda5 t 
               else if h == ' '
                    then ajuda3 t 
                    else []  


{- | A função xponto recebe a String do Nível, e calcula a coordenada X.

== Exemplo de utilização :

>>>xponto  ["aaca","abba","adaa","0 1 N","ASDAA"] 
0
-}  

xponto :: Nivel -> Int
xponto l = strInt (ajuda3 (head(doisUlt l)))



{- | A função nulas recebe a String do Nível, e verifica se existem listas vazias no nivel.

== Exemplos de utilização :

>>>xponto  ["aaca","abba","","0 1 N","ASDAA"] 
True 

>>>xponto  ["aaca","abba","aaaa","0 1 N","ASDAA"] 
False
-}

nulas :: Nivel -> Bool
nulas [] = False 
nulas (h:t) = if null h 
              then True 
              else nulas t 


{- | A função erroN recebe a String do Nível, e verifica em que linhas se deu o erro, por haver uma lista vazia.

== Exemplo de utilização :

>>>erroN   ["aaca","abba","","0 1 N","ASDAA"] 
3
-}

erroN :: Nivel -> Int
erroN [] = 1
erroN (h:t) = if null h 
              then 1 
              else 1 + erroN t 
