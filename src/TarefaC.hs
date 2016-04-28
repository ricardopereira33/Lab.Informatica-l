{- | 
Module      : Main
Description : Módulo Haskell contendo funções para verificar se o jogo foi concluido com sucesso ou não.
Copyright   : Ricardo António Gonçalves Pereira <a74185@alunos.uminho.pt>
              João Ismael Barros dos Reis <a75372@alunos.uminhho.pt  


Módulo Haskell para a Tarefa C.
-}

module Main where

import Data.Char

main = do inp <- getContents
          putStrLn (tarefa (lines inp))


testa f = do inp <- readFile f
             putStrLn (tarefa (lines inp))


{- | A função tarefa é a função principal, pois reúne todas as funções elaboradas ao longo deste módulo Haskell, 
tendo como objectivo verificar se os comandos aplicados em sequência, perimitem conluir o Nivel ou não, sendo preciso 
ligar todas as lâmpadas presentes no mapa.

== Exemplos de utilização :

>>>tarefa ["acbbba","bbbAab","2 0 N","ASDE"]
"INCOMPLETO"

>>>tarefa ["aD","Bc","0 1 S","SELSESL"]
"0 0\n1 1\nFIM 7"
-}


tarefa :: [String] -> String
tarefa l = if null l 
           then "INCOMPLETO"
           else if length (lines (result (ligacao3 (sequenceF l) (auxiliar4 (reverse (mapa l)) 0 0) []))) == length  (auxiliar4 (reverse (mapa l)) 0 0)
                then unlines (verifica2 (sequenceF l)) ++ "FIM " ++ (show (verificar1 (sequenceF l) (ligacao4 (sequenceF l) (auxiliar4 (reverse (mapa l)) 0 0) [] )))
                else unlines (verifica2 (sequenceF l)) ++ "INCOMPLETO" 


{- | O tipo Sequencia, representa a lista, com a sequencia dos comandos aplicados ao robo, representado a sequência numa lista de Nivel.-}
type Sequencia     = [Nivel]
{- | O tipo Nivel, representa uma String de Strings, ou seja, as linhas do mapa,e as coordenadas e comandos. -}
type Nivel         = [String]
{- | O tipo Mapa, representa uma String das Linhas do mapa do jogo.-}
type Mapa          = [Linha]
{- | O tipo Coordenadas, é dado por uma String.-}
type Coordenadas   = String
{- | O tipo Comandos, é dado por uma String.-}
type Comandos      = String
{- | O tipo Resultado, é dado por uma String.-}
type Resultado     = String 
{- | O tipo Linha, respresenta uma linha do mapa, numa String. -}
type Linha         = String  
{- | O tipo Orientacao, representa a orientação do robo no mapa, que é dado num Char.-}
type Orientacao    = Char
{- | o tipo Vx, respresenta o valor de x, das Coordenadas.-}
type Vx            = String
{- | o tipo Vy, respresenta o valor de y, das Coordenadas.-}
type Vy            = String
{- | O tipo Posicao, representa a letra onde se situa o robo no mapa.-}
type Posicao       = String
{- | O tipo CoordComandos, é dado por uma lista de String, contendo as Coordenadas e os Comandos.-}
type CoordComandos = [String]
{- | O tipo ComandosV, é dado por um Int, indicando o número de comandos executados com sucesso.-}
type ComandosV     = Int 
{- | O tipo Ligados é dado por uma lista de String, onde se encontra as coordenadas das luzes ligadas.-}
type Ligadas       = [Coordenadas]
{- | O tipo Desligados é dado por uma lista de String, onde se encontra as coordenadas das luzes desligadas.-}
type Desligadas       = [Coordenadas]


{- | A função sequence1 recebe o Nivel, e tem como suporte a função tarefa2, sendo que esta verifica se o 
comando a aplicar é válido ou não. Caso o comando seja válido, devolve o mesmo Nivel, alterando-lhe as coordenadas, para 
a próxima posição, e os comandos, retirando-lhe o comando que foi aplicado. 

== Exemplo de utilização :

>>>sequence1 ["acbbba","bbbAab","2 0 N","ASDE"]
["acbbba","bbbAab","2 1 N","SDE"]
-}

sequence1 :: Nivel -> Nivel
sequence1  [] = []
sequence1 l = if tarefa2 l /= "ERRO"
              then ((init(init l))++ [tarefa2 l] ++ [tail ( last l)]) 
              else ((init l) ++ [tail (last l)]) 

{- | A função sequence2 recebe um Nivel, e forma uma sequência apartir dele, ou seja, tendo a função sequence1 como auxiliar, aplica 
a função sequence1 ao Nivel, e volta aplicar o mesmo processo ao Nivel obtido. Assim vai se formando a sequência dos comandos aplicados, e
quando obtermos um Nivel com apenas com um comando, o processo para, devolvendo uma lista vazia.

== Exemplo de utilização :

>>>sequence2 ["acbbba","bbbAab","2 0 N","ADA"]
[["acbbba","bbbAab","2 1 N","D"],["acbbba","bbbAab","2 1 E","A"]]
-}
sequence2 :: Nivel -> Sequencia
sequence2 [] = []
sequence2 l = if length (last l)== 1 
              then []
              else (sequence1 l) : sequence2 ( sequence1 l )  

{- | A função sequence3 recebe uma Sequência formada pela função sequence2 e o Nivel, e acrescenta-lhe o Nivel na forma original, sem ter sido aplicado um comando, 
formando assim uma sequência completa. 

== Exemplo de utilização :

>>>sequence3 [["acbbba","bbbAab","2 1 N","DA"],["acbbba","bbbAab","2 1 E","A"]] ["acbbba","bbbAab","2 0 N","ADA"]
[["acbbba","bbbAab","2 0 N","ADA"],["acbbba","bbbAab","2 1 N","DA"],["acbbba","bbbAab","2 1 E","A"]]
-}

sequence3 :: Sequencia -> Nivel -> Sequencia
sequence3 l x = x : l

{- | A função sequenceF recebe apenas um Nivel e através das funções sequence3 e sequence2, forma a sequência completa.

== Exemplo de utilização :

>>>sequenceF ["acbbba","bbbAab","2 0 N","ADA"]
[["acbbba","bbbAab","2 0 N","ADA"],["acbbba","bbbAab","2 1 N","DA"],["acbbba","bbbAab","2 1 E","A"]]
-}

sequenceF :: Nivel -> Sequencia
sequenceF l = sequence3 (sequence2 l) l       


{- | A função verifica2 recebe uma Sequência e verifica os Niveis, onde o comando Ligar (L), está ser aplicado com sucesso.
Caso esteja a ser aplicado com sucesso, devolve a coordenada dessa posição.

== Exemplo de utilização :

>>>verifica2 [["acbbba","bbbAab","2 0 N","DSL"],["acbbba","bbbAab","2 0 E","SL"],["acbbba","bbbAab","3 0 E","L"]]
["3 0"]
-}

verifica2 :: Sequencia -> [Coordenadas]
verifica2 [] = []
verifica2 (h:t) = if isUpper (head (posicao h)) && lampada h 
                  then veri : verifica2 t
                  else verifica2 t 
      where veri = init (init(last (init h)))


{- | A função ligacao3 recebe uma Sequência, uma lista das coordendas das luzes desligadas, e uma lista das luzes ligadas, e devolve a lsita das luzes ligadas.
Em geral, a função verifica Nivel a Nivel, as lâmpadas que foram ligadas e desligadas. Caso se ligue uma lâmpada, as coordenadas dessa posição entram na lista
das ligadas, e simultãneamente retira a mesma coordenada da lista das luzes desligadas. Caso se deligue uma lâmpada, o processo é inverso, acrescenta-se a 
coordenada a lista das luzes de desligadas, e retira-se da lista das luzes ligadas.

== Exemplo de utilização :

>>>ligacao3 [["acbbba","bbbAab","2 0 N","DSL"],["acbbba","bbbAab","2 0 E","SL"],["acbbba","bbbAab","3 0 E","L"]] ["3 0"] []
["3 0"]

-}


ligacao3 :: Sequencia -> Desligadas -> Ligadas -> Ligadas
ligacao3 _ [] p = p 
ligacao3 [] l p = p  
ligacao3 (h:t) l f = if lampada h && isUpper (head(posicao h)) && existe s l 
                     then ligacao3 t (removeL s l) (s:f)
                     else if lampada h && isUpper (head(posicao h)) && existe s f 
                          then ligacao3 t (s:l)  (removeL s f)
                          else ligacao3 t l f 
       where s = init (init(head (doisUlt h)))

{- | A função removeL, recebe umas Coordenadas e uma lista de Coordenadas, e verifica se as Coordenadas dadas se encontram na lista. 
Assim, se a lista possuir as Coordenadas, as mesmas são removidas da lista.

== Exemplo de utilização :

>>> removeL "1 0" ["1 0","3 2"]
["3 2"]
-}

removeL :: Coordenadas -> [Coordenadas] -> [Coordenadas]
removeL l [] = []
removeL l (h:t) = if l == h 
                  then t 
                  else h: removeL l t

{- | A função existe, recebe umas Coordenadas e uma lista de Coordenadas, e verifica se as Coordenadas dadas pertençam a lista. 

== Exemplo de utilização :

>>> existe "1 0" ["1 0","3 2"]
True 
-}

existe :: Coordenadas -> [Coordenadas] -> Bool
existe a [] = False
existe a (x:xs) = if a == x then True else existe a xs

{- | A função result, recebe uma lista de Coordenadas, devolve numa String, ou seja, todos elementos da lista, ficam juntos numa String, 
separados pelo caracter '\n'. 

== Exemplo de utilização :

>>> result ["1 0","3 2"]
"1 0\n3 2\n"
-}

result :: [Coordenadas] -> String 
result [] = []
result (h:t) = result t ++ h ++ ['\n']

{- | A função ligacao4, recebe uma Sequencia, uma lista das luzes desligadas e uma das luzes ligadas. Tendo o mesmo processo que a função ligacao3, 
esta função difere no seu output, isto é, em vez de devolver a lista das luzes ligadas, devolve a sequência restante do comandos que não 
foram aplicados, após ter conluido o nivel. 

== Exemplo de utilização :

>>>ligacao4 [["acbbba","bbbAab","2 0 N","DSLA"],["acbbba","bbbAab","2 0 E","SLA"],["acbbba","bbbAab","3 0 E","LA"],["acbbba","bbbAab","3 0 E","A"]] ["3 0"] []
["acbbba","bbbAab","3 0 S","LA"]

-}

ligacao4 :: Sequencia -> Desligadas -> Ligadas -> Sequencia
ligacao4 d [] p = d 
ligacao4 [] l p = []
ligacao4 (h:t) l f = if lampada h && isUpper (head(posicao h)) && existe s l 
                     then ligacao4 t (removeL s l) (s:f)
                     else if lampada h && isUpper (head(posicao h)) && existe s f 
                          then ligacao4 t (s:l) (removeL s f)
                          else ligacao4 t l f 
       where s = init (init(head (doisUlt h)))

{- | A função verificar1 recebe duas Sequência, e verifica se a segunda Sequência é vazia ou não. Caso seja vazia, 
aplica a função passosV a primeira sequência. Caso não seja vazia, retira-se da primeria Sequência a segunda Sequência, e 
posteriormente aplica-se a função passosV. Logo, a função devolve um Int.

== Exemplo de utilização :

>>>verificar1 [["acbbba","bbbAab","2 0 N","ADA"],["acbbba","bbbAab","2 1 N","DA"],["acbbba","bbbAab","2 1 E","A"]] ["acbbba","bbbAab","2 1 E","A"]
2
-}

verificar1 :: Sequencia -> Sequencia -> Int
verificar1 l s = if null s 
                 then passosV l
                 else passosV (take (length l - length s) l )


{- | A função passosV recebe uma Sequência, e em cada Nivel vai verificar se o comando a ser aplicado é válido. Desta forma 
calcula o número de comandos válidos na Sequência. 

== Exemplo de utilização :

>>>passosV [["acbbba","bbbAab","2 0 N","ADA"],["acbbba","bbbAab","2 1 N","DA"],["acbbba","bbbAab","2 1 E","A"]]
3 
-}

passosV :: Sequencia -> ComandosV
passosV [] = 0
passosV (h:t) = if tarefa2 h /= "ERRO" 
                then 1 + passosV t
                else passosV t
 

{- | A função auxiliar3 recebe uma Linha do Mapa, e devolve as coordenadas dos pontos que possuiem lâmpadas, isto é,
as posições que tem letras maiúsculas.

== Exemplo de utilização :

>>>auxiliar3 "acbBba" 0 0
["3 0"] 
-}

auxiliar3 :: Linha -> Int -> Int -> [Coordenadas]
auxiliar3 [] x y = []
auxiliar3 (h:t) x y |isUpper h = (show x ++" "++ show y ): auxiliar3 t (x+1) y
                    |otherwise = auxiliar3 t (x+1) y

{- | A função auxiliar4 recebe uma Mapa, e devolve todas as coordenadas dos pontos que possuiem lâmpadas, isto é,
as posições que tem letras maiúsculas.

== Exemplo de utilização :

>>>auxiliar4 ["acbBba","bbbAab"] 0 0
["3 0","3 1"] 
-}

auxiliar4 :: Mapa -> Int -> Int -> [Coordenadas]
auxiliar4 [] x y = []
auxiliar4 (h:t) x y = (auxiliar3 h x y) ++ (auxiliar4 t x (y+1))





{- | Função prinicpal da tarefa B do projecto, que dado um Nivel, devolve-nos a próxima posição do robô.

== Exemplos de utilização :

>>>tarefa2 ["acbbba","bbbAab","2 0 N","ASDE"]
"2 1 N"

>>>tarefa2 ["acCdba","ddbaab","1 1 N","ASDE"]
"ERRO"

-}

tarefa2 :: Nivel -> Resultado
tarefa2 l = if null l 
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
 --fsfsd