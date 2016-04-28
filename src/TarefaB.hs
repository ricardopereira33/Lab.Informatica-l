{- | 
Module      : Main
Description : Módulo Haskell contendo funções para verificar se um comando é aplicavel ou não.
Copyright   : Ricardo António Gonçalves Pereira <a74185@alunos.uminho.pt>
              João Ismael Barros dos Reis <a75372@alunos.uminhho.pt  


Módulo Haskell para a Tarefa B.
-}

module Main where

import Data.Char

main = do inp <- getContents
          putStrLn (tarefa (lines inp))


testa f = do inp <- readFile f
             putStrLn (tarefa (lines inp))

{- | A função tarefa é a função principal, pois reúne todas as funções elaboradas ao longo deste módulo Haskell, 
tendo como objectivo verificar se o primeiro comando excutado for válido ou não. Caso seja válido, dá as coordenadas
da proxima posição do robô. Caso não seja válida, devolve uma String ERRO.

== Exemplos de utilização :

>>>tarefa ["acbbba","bbbAab","2 0 N","ASDE"]
"2 1 N"

>>>tarefa ["acCdba","ddbaab","1 1 N","ASDE"]
"ERRO"
-}

tarefa :: Nivel -> Resultado
tarefa l = if null l 
	         then "ERRO"
           else if rotacao1 l 
                then rotacao3 l (head(last l))
                else if avancarA l
                     then avancar4 l (last (last (init l)))
                     else if avancarS l 
                          then avancar5 l (last (last (init l))) 
                          else if lampada l
                               then lampada1 l 
                               else "ERRO"



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
{- | O tipo Posicao, representa a letra onde se situa o robo no mapa.-}
type Posicao = String
{- | O tipo CoordComandos, é dado por uma lista de String, contendo as Coordenadas e os Comandos.-}
type CoordComandos =  [String]


{- | A função mapa, é uma função que recebe a lista completa do nivel, 
e retira os dois últimos elementos, ou seja, as coordenadas e os comandos. 

== Exemplo de utilização :

>>>mapa ["aaabba","bbbaab","1 2 N","ASDE"]
["aaabba",bbbaab"] -} 

mapa :: Nivel -> Mapa
mapa [] = []
mapa l = init ( init (l))   

{- | A função doisUlt recebe a String do Nivel, e retira o mapa, dando a lista das coordenadas e dos comandos.

== Exemplo de utilização :

>>>doisUlt ["aaaa","aaaa","aaaa","0 1 N","ASDAA"]
["0 1 N","ASDAA"]
 -}


doisUlt :: Nivel -> CoordComandos
doisUlt [] = []
doisUlt l = if length l <= 2 
            then l 
	          else drop ((length l) - 2) l


{- | A função posicaoY dá nos a linha em que o robô se encontra. Recebe o Mapa e um Int, e a linha 
em que se encontra o robô.

== Exemplo de utilização :

>>>posicaoY ["aBac","aAca","aabb"] 1
["aAca"]

-}
posicaoY :: Nivel -> Int -> [Linha]
posicaoY l y = if y>0 
               then posicaoY (init l) (y-1)
               else ult l
 
{- | A função ult é uma função auxiliar, que quando o valor do argumento Int tomar o valor O, a função
ult recebe a Lista de String que da função posicaoY resultou, e retira a última String. A última String corresponde
a linha onde se encontra o robô. Caso a lista possuir apenas uma String, devolve a própria, caso contrário, devolve
a última, como a pouco referi.

== Exemplo de utilização :

>>>ult ["aBac","aAca"] 
["aAca"]

-}


ult :: Nivel -> [Linha]
ult [] = []
ult l = if length l == 1 
	      then l 
	      else drop ((length l) - 1) l



{- | A função mudar é um função que tem como objectivo mudar a lista de Linha, porveniente 
da função posicaoY, para uma String.

== Exemplo de utilização :

>>>mudar2 ["aAca"]
"aAca"
-}

mudar :: [Linha] -> Linha
mudar l = mudar2 (unlines l)


{- | A função mudar2 recebe a String da linha onde se encontra o robô, para retirar os 
caracteres '\n' existentes nessa String.

== Exemplo de utilização :

>>>mudar2 "aAca\n"
"aAca"
-}

mudar2 :: Linha -> Linha
mudar2 [] = []
mudar2 (h:t) = if h/='\n' 
               then h: mudar2 t
               else []



{- | A função posicaoX dá nos a coluna em que o robô se econtra, isto é, recebe a String proveniente da função posicaoY
e dessa String retira a String com a letra na qual o robô, se encontra posicionado.

== Exemplo de utilização :

>>>posicaoX ["aAca"] 2
"c"

-}

posicaoX :: Linha -> Int -> Posicao
posicaoX [] x = []
posicaoX l x = if x>0 
               then posicaoX (drop 1 l) (x-1)
               else [head l]


{- | A função posicao, sendo a junçao da função posicaoY e posicaoX, dá nos o local exacto do robô no mapa.

== Exemplo de utilização :

>>>posicao ["aBac","aAca","aabb","2 1 N","ASDAA"]
"c"

-}

posicao :: Nivel -> Posicao 
posicao l = posicaoX (mudar (posicaoY (mapa l) (yponto l))) (xponto l)


{- | A função yponto recebe a String do Nível, e calcula a coordenada Y.

== Exemplo de utilização :

>>>yponto  ["aaca","abba","adaa","0 1 N","ASDAA"] 
1
-}  

yponto :: Nivel -> Int
yponto l = strInt (ajuda5 (head(doisUlt l)))


{- | A função xponto recebe a String do Nível, e calcula a coordenada X.

== Exemplo de utilização :

>>>xponto  ["aaca","abba","adaa","0 1 N","ASDAA"] 
0
-}  

xponto :: Nivel -> Int
xponto l = strInt (ajuda3 (head(doisUlt l)))

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
ajuda5 (h:t) = if isNumber h 
               then ajuda5 t 
               else if h == ' '
                    then ajuda3 t 
                    else []  


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


{- | A função posicaoE, como a função posicao, dá-nos a posicao do lado Este do robô. 

== Exemplo de utilização :

>>>posicaoE ["aBac","aAca","aabb","2 1 N","ASDAA"] 
"a"
-}

posicaoE :: Nivel -> Posicao  
posicaoE l = posicaoX (mudar (posicaoY (mapa l) (yponto l))) ((xponto l)+1)


{- | A função posicaoE, como a função posicao, dá-nos a posicao do lado Oeste do robô.

== Exemplo de utilização :

>>>posicaoO ["aBac","aAca","aabb","1 2 N","ASDAA"]
"A"
 -}

posicaoO :: Nivel -> Posicao  
posicaoO l = posicaoX (mudar (posicaoY (mapa l) (yponto l))) ((xponto l)-1)


{- | A função posicaoE, como a função posicao, dá-nos a posicao do lado Norte do robô.

== Exemplo de utilização : 

>>>posicaoN ["aBac","aAca","aabb","1 2 N","ASDAA"]
"a"
-}

posicaoN :: Nivel -> Posicao  
posicaoN l = posicaoX (mudar (posicaoY (mapa l) ((yponto l)+1))) (xponto l)


{- | A função posicaoE, como a função posicao, dá-nos a posicao do lado Sul do robô. 

== Exemplo de utilização :

>>>posicaoS ["aBac","aAca","aabb","1 2 N","ASDAA"]
"b"
-}

posicaoS :: Nivel -> Posicao
posicaoS l = posicaoX (mudar (posicaoY (mapa l) ((yponto l)-1))) (xponto l)


{- | A função comando, retira do Nivel, a String correspondente aos Comandos, e posteriormente 
retira o primeiro comando a ser aplicado ao robô.  

== Exemplo de utilização :

>>>comando ["aBac","aAca","aabb","1 2 N","ASDAA"]
'A'
-}


comando :: Nivel -> Char
comando l = head (last l)


{- | A função rotacao1 recebe o Nivel, e verifica se o comando a aplicar ao robô, 
é E (Esquerda) ou D (Direita), sendo estes comandos, que fazem apenas rodar o robô.


== Exemplos de utilização :

>>>rotacao1 ["aBac","aAca","aabb","1 2 N","EASDAA"]
True

>>>rotacao1 ["aBac","aAca","aabb","1 2 N","ASDAA"]
False

-}

rotacao1 :: Nivel -> Bool 
rotacao1 l = head ( last l ) == 'E' || head ( last l ) == 'D' 

{- | A função rotacao2 recebe a String referente ás Coordenadas, e verifica em primeiro lugar, a 
oreintação do robô, e posteriormente, a orientação em que fica o robô, após o comando (E ou D) ser aplicado.


== Exemplos de utilização :

>>>rotacao2 "1 2 N" 'E'
'O'

>>>rotacao2 "1 2 N" 'D'
'E'

-}


rotacao2 :: Coordenadas -> Char -> Orientacao
rotacao2 l x | last l == 'N' && x == 'E' = 'O'
             | last l == 'N' && x == 'D' = 'E'
             | last l == 'S' && x == 'E' = 'E'
             | last l == 'S' && x == 'D' = 'O'
             | last l == 'O' && x == 'E' = 'S'
             | last l == 'O' && x == 'D' = 'N'
             | last l == 'E' && x == 'E' = 'N'
             | last l == 'E' && x == 'D' = 'S'

{- | A função rotacao3 recebe o Nivel, e a Oreintação do robô, e altera a Orientação, nas Coordenadas, cosoante a Orientação recebida.

== Exemplos de utilização :

>>>rotacao3 ["aBac","aAca","aabb","1 2 N","EASDAA"] 'E'
"1 2 O"

>>>rotacao3 ["aBac","aAca","aabb","1 2 N","DASDAA"] 'D'
"1 2 E"

-}

rotacao3 :: Nivel -> Orientacao -> Coordenadas
rotacao3 l x = (init(last(init l))) ++ [rotacao2 (last(init l)) x]

-- Avançar

{- | A função avancarA recebe o Nivel, e verifica se o comando a aplicar 
ao robô, é o de Avançar (A). 

== Exemplos de utilização :

>>>avancarA ["aBac","aAca","aabb","1 2 N","EASDAA"] 
False

>>>avancarA ["aBac","aAca","aabb","1 2 N","ADSDAA"] 
True 

 -}

avancarA:: Nivel -> Bool
avancarA l = head ( last l ) == 'A' 


{- | A função avancarS recebe o Nivel, e verifica se o comando a aplicar 
ao robô, é o de Saltar (S). 

== Exemplos de utilização :

>>>avancarA ["aBac","aAca","aabb","1 2 N","ASDAA"] 
False

>>>avancarA ["aBac","aAca","aabb","1 2 N","SDEAA"] 
True 

 -}

avancarS :: Nivel -> Bool 
avancarS l = head ( last l ) == 'S'

{- | A função avancar2 recebe o Nivel e a orientação do robô. Consoante a orientação, a função calcula 
a próxima coordenada depois de aplicar o comando Avançar (A).

== Exemplos de utilização :

>>>avancar2 ["aBac","aAaa","aabb","1 2 N","AASDAA"] 'N'
"2 2 N"

>>>avancar2 ["aBac","aAba","aabb","1 2 S","ADSDAA"] 'S'
"0 2 S" 

 -}

avancar2 :: Nivel -> Orientacao -> Resultado
avancar2 l x  | x == 'N' = (show (xponto l))++" "++(show ((yponto l)+1))++" "++[(last (last (init l)))]
              | x == 'E' = (show ((xponto l)+1))++" "++(show (yponto l))++" "++[(last (last (init l)))]
              | x == 'O' = (show ((xponto l)-1))++" "++(show (yponto l))++" "++[(last (last (init l)))]
              | x == 'S' = (show (xponto l))++" "++(show ((yponto l)-1))++" "++[(last (last (init l)))]
              
{- | A função avancar3 recebe o Nivel e a orientação do robô. Consoante a orientação, a função calcula 
a próxima coordenada depois de aplicar o comando Saltar (S).

== Exemplos de utilização :

>>>avancar3 ["aBbc","aAca","aabb","1 2 N","SASDAA"] 'N'
"2 2 N"

>>>avancar3 ["aBac","aAca","aabb","1 2 S","SDSDAA"] 'S'
"0 2 S" 

 -}

avancar3 ::  Nivel -> Orientacao -> Resultado
avancar3 l x  | x == 'N' = (show (xponto l))++" "++(show ((yponto l)+1))++" "++[(last (last (init l)))]
              | x == 'E' = (show ((xponto l)+1))++" "++(show (yponto l))++" "++[(last (last (init l)))]
              | x == 'O' = (show ((xponto l)-1))++" "++(show (yponto l))++" "++[(last (last (init l)))]
              | x == 'S' = (show (xponto l))++" "++(show ((yponto l)-1))++" "++[(last (last (init l)))]

{- | A função avancar4 recebe o Nivel e a orientação do robô, e caso a próxima posição não seja possivel 
de ser ocupada com o comando A, devolve a String ERRO, se não, recorre a função avancar2 para dar as coordenadas da próxima posição.

== Exemplos de utilização :

>>>avancar4 ["aBbc","aAca","aabb","2 2 N","AASDAA"] 'N'
"ERRO"

>>>avancar4 ["aBac","aAca","aacb","1 2 S","ADSDAA"] 'S'
"0 2 S" 

 -}

avancar4 :: Nivel -> Orientacao -> Resultado
avancar4 l x | x == 'N' && posicaoN (mapaC l) == "" = "ERRO"
             | x == 'N' && (ord (head (posicao (mapaC l))) - ord (head (posicaoN (mapaC l))) == 0) = avancar2 l x 
             | x == 'S' && yponto l == 0 && (posicaoS (mapaC l) == "" || posicaoS l == posicao l ) = "ERRO"  
             | x == 'S' && (ord (head (posicao (mapaC l))) - ord (head (posicaoS (mapaC l))) == 0) = avancar2 l x
             | x == 'E' && posicaoE (mapaC l) == "" = "ERRO"
             | x == 'E' && (ord (head (posicao (mapaC l))) - ord (head (posicaoE (mapaC l))) == 0) = avancar2 l x
             | x == 'O' && xponto l == 0 && (posicaoO (mapaC l) == "" || posicaoO l == posicao l ) = "ERRO" 
             | x == 'O' && (ord (head (posicao (mapaC l))) - ord (head (posicaoO (mapaC l))) == 0) = avancar2 l x 
             | otherwise = "ERRO"

{- | A função avancar5 recebe o Nivel e a orientação do robô, e tal como a função avancar4, caso a próxima posição não seja possivel 
de ser ocupada com o comando S, devolve a String "ERRO", se não, recorre a função avancar3 para dar as coordenadas da próxima posição.

== Exemplos de utilização :

>>>avancar5 ["aBbc","aDca","aabb","0 1 N","SASDAA"] 'N'
"ERRO"

>>>avancar5 ["aBac","aAca","aabb","1 2 S","SDSDAA"] 'S'
"0 2 S" 

 -}

avancar5 :: Nivel -> Orientacao -> Resultado
avancar5 l x | x == 'N' && posicaoN (mapaC l) == "" = "ERRO"
             | x == 'N' && abs (ord (head (posicao (mapaC l))) - ord (head (posicaoN (mapaC l)))) == 1 = avancar3 l x
             | x == 'S' && yponto l == 0 && (posicaoS (mapaC l) == "" || posicaoS l == posicao l ) = "ERRO"  
             | x == 'S' && abs (ord (head (posicao (mapaC l))) - ord (head (posicaoS (mapaC l)))) == 1 = avancar3 l x
             | x == 'E' && posicaoE (mapaC l) == "" = "ERRO" 
             | x == 'E' && abs (ord (head (posicao (mapaC l))) - ord (head (posicaoE (mapaC l)))) == 1 = avancar3 l x 
             | x == 'O' && xponto l == 0 && (posicaoO (mapaC l) == "" || posicaoO l == posicao l ) = "ERRO" 
             | x == 'O' && abs (ord (head (posicao (mapaC l))) - ord (head (posicaoO (mapaC l)))) == 1 = avancar3 l x 
             | otherwise = "ERRO"

{- | A função transformar1 recebe uma String, e converte todas as letras maiúsculas para 
minúsculas. 

== Exemplo de utilização :

>>>transformar1 "aBbc"
"abbc"

 -}

transformar1 :: Linha -> Linha 
transformar1 [] = [] 
transformar1 (h:t) = if ord h < 97 
                     then chr ((ord h) + 32) : transformar1 t
                     else h : transformar1 t 

{- | A função transformar2 recebe uma lista de Strings, e aplica a função transforma1 recursivamente. Assim, converte todas as letras 
maiúsculas para minúsculas de todas as Strings da lista.

== Exemplo de utilização :

>>>transformar2 ["aBac","aAca","aabb"]
["abac","aaca","aabb"]
 -}

transformar2 :: [Linha] -> [Linha] 
transformar2 [] = [] 
transformar2 (h:t) = [transformar1 h] ++ transformar2 t 


{- | A função mapaF recebe o Nivel, e apartir do mapa, converte todas as letras maiúsculas para 
minúsculas, para que se possa comparar todas as letras do mapa. 

== Exemplo de utilização :

>>>mapaF ["aBac","aAca","aabb","0 1 N","ASDE"]
["abac","aaca","aabb"]
 -}

mapaF :: Nivel -> Mapa
mapaF l = transformar2 (mapa l)


{- | A função mapaC recebe o Nivel, e com a função mapaF modifica o mapa, e posteriormente acrescenta-lhe as coordenadas e os comandos, 
formando assim, o mesmo Nivel, só que com o mapa constituido apenas por letras minúsculas.

== Exemplo de utilização :

>>>mapaC ["aBac","aAca","aabb","0 1 N","ASDE"]
["abac","aaca","aabb","0 1 N","ASDE"]
 -}

mapaC :: Mapa -> Nivel
mapaC l = (mapaF l) ++ (doisUlt l)

-- LAMPADA 

{- | A função lampada recebe o Nivel, e verifica se o comando a ser aplicado é o Ligar (L).

== Exemplos de utilização :

>>>lampada ["aBac","aAca","aabb","0 1 N","ASDE"]
False

>>>lampada ["aBac","aAca","aabb","1 1 N","LASDE"]
True
 -}

lampada :: Nivel -> Bool
lampada l = head ( last l ) == 'L' 

{- | A função lampada1 recebe o Nivel, e tenho como base que é o comando L a ser aplicado, verifica se o comando, 
é aplicavél ou não. Assim, se a posição do robô, for uma letra maiúscula, a função devolve as coordenadas do ponto onde 
se econtra, se não devolve a String ERRO.

== Exemplos de utilização :

>>>lampada1 ["aBac","aAca","aabb","0 1 N","LASDE"]
"ERRO"

>>>>lampada1 ["aBac","aAca","aabb","1 1 N","LASDE"]
"1 1 N"

 -}

lampada1 :: Nivel -> Coordenadas
lampada1 l = if ord (head ( posicao l )) <= 90 && ord (head ( posicao l )) >= 65
             then last ( init l )
             else "ERRO"
 --fsdf