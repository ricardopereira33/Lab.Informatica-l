{- | 
Module      : Main
Description : Módulo Haskell contendo funções para produzir uma animação 3D, através do x3dom e código html.
Copyright   : Ricardo António Gonçalves Pereira <a74185@alunos.uminho.pt>
              João Ismael Barros dos Reis <a75372@alunos.uminhho.pt  


Módulo Haskell para a Tarefa E.
-}

module Main where 

import Data.Char
import Data.Function


main = do inp <- getContents
          putStrLn (tarefa (lines inp))

testa f = do inp <- readFile f
             putStrLn (tarefa (lines inp))

{- | A função func é uma função auxiliar, que na realização deste módulo Haskell, permitia passar o output da função principal para um ficheiro, 
que se tornava numa forma fácil de poder verificar se os outputs estavam a realizar-se de forma correta.
-}

func :: IO ()
func = writeFile "file.html" (tarefa ["aAa","aAa","aAa","0 0 N","AADALDALAL"])


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
{- | o tipo Vx, respresenta o valor de x.-}
type Vx = Int
{- | o tipo Vy, respresenta o valor de y.-}
type Vy = Int
{- | o tipo Vz, respresenta o valor de z, para a representação em 3D.-}
type Vz = Int
{- | O tipo Posicao, representa a letra onde se situa o robo no mapa.-}
type Posicao = Char
{- | O tipo Html, representa o código html apresentado em uma lista de String.-}
type Html = [String]
{- | O tipo LinhaHtml, representa uma linha de código html apresentado em uma String.-}
type LinhaHtml = String 
{- | O tipo CoordLampadas, representa a String, com as coordenadas das lâmpadas.-}
type CoordLampadas = String

{- | A função tarefa é a função principal, pois reúne todas as funções elaboradas ao longo deste módulo Haskell, 
tendo como objectivo reproduzir um código html, onde este apresenta uma animação 3D, com base em x3dom.
-}

tarefa :: Nivel -> Resultado
tarefa l = unlines (["<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"",
                    "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">",
                    "<html xmlns=\"http://www.w3.org/1999/xhtml\">",
                    "",
                    "",
                    "<head>",
                    "<meta http-equiv=\"X-UA-Compatible\" content=\"chrome=1\" />",
                    "<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\" />",
                    "<script type=\"text/javascript\" src=\"http://www.x3dom.org/release/x3dom.js\"></script>",
                    "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://www.x3dom.org/release/x3dom.css\"/>",
                    "",
                    "<title>Hello World</title>",
                    "",
                    "<style type=\"text/css\">",
                    "",
                    "x3d",
                    "{",
                    "right: 0px;",
                    "border: solid 4px rgb(240,240,240);",
                    "background: rgba(100, 100, 100, 0.8);",
                    "width:600px;",
                    "height:320px;",
                    "margin-right:1px;",
                    "float:left;",
                    "",
                    "",
                    "",
                    "}",
                    "",
                    "",
                    "body",
                    "{",
                    "margin-left: 5em;",
                    "margin-top: 3em;",
                    "font-size: 90%;",
                    "font-family: sans-serif;",
                    "background-image: url('http://i.imgur.com/hn3xxdw.gif');",
                    "color: lightgray;",
                    "}",
                    "",
                    "h1",
                    "{",
                    "color: rgb(240, 240, 240);",
                    "text-transform: uppercase;",
                    "margin-bottom: -14px;",
                    "}",
                    "",
                    "p",
                    "{",
                    "color: lightgrey;",
                    "margin-bottom: 3em;",
                    "clear:right;",
                    "}",
                    "",
                    "p.autores {",
                    "margin-bottom: 0.5em;",
                    "}",
                    "",
                    "",
                    "div.test {",
                    "clear:both;",
                    "margin-bottom: 3em;",
                    "}",
                    "",
                    "",
                    "</style>",
                    "",
                    "</head>",
                    "",
                    "",
                    "<body bgcolor=\"#f an006400\">",
                    "<h1>Animacao 3D</h1>",
                    "<p class=\"desc\"> Deslocamento do robot as lampadas presentes no nivel</p>",
                    "",
                    "",
                    "<X3D xmlns=\"http://www.web3d.org/specifications/x3d-namespace\" id=\"boxes\">",
                    "<Scene>",
                    "<Shape DEF=\"tile\">",
                    "<Appearance>",
                    "<Material diffuseColor='0.9411764705882353 0.9411764705882353 0.9411764705882353'/>",
                    "</Appearance>",
                    "<Box size='.98 .98 .98'/>",
                    "</Shape>",
                    "<Shape DEF=\"tileL\">",
                    "<Appearance>",
                    "<Material def=\"corLam\" diffuseColor='0 0 1.0'/>",
                    "</Appearance>",
                    "<Box size='.98 .98 .98'/>",
                    "</Shape>",
                    ""]
                    ++ (formaLamp (coordLuz (words coord)) 1 )++
                    [""]
                    ++ (formaTab2 mapa 0 0)++                    
                    [""]
                    ++ [formaRobo l] ++
                    ["<Shape>",
                    "<Appearance>",
                    "<Material diffuseColor='0.25 .25 .25'/>",
                    "</Appearance>",
                    "<Cone></Cone>",
                    "</Shape>",
                    "</Transform>",
                    "",
                    ""]
                    ++ formaRota l ++
                    ["",
                    "</Scene>",
                    "</X3D>",
                    "<div class=\"test\">",
                    "</div>",
                    "",
                    "<p class=\"autores\">  a75372 <strong>Joao Reis</strong> | a74185 <strong>Ricardo Pereira</strong> </p>",
                    "<img src=\"http://i.imgur.com/QgYr5nj.png\"/>",
                    "",
                    "",
                    "</body>",
                    "</html>"])
      where mapa  = reverse (init ( init l))
            movim = formaCam l (last l) (xponto l) (yponto l) valorZ (last (last(init l))) []
            coord = drop (length ( retira ( movim ))) movim
            valorZ   = ((conve(posicao mapa (xponto l) (yponto l)))+1)

{- | A função formaTab, é uma função que recebe uma linha do mapa, dois Int, servindo estes como acumuladores, dando as coordenadas no decorrer da função. 
A função devolve um código html, que apresenta uma linha do tabuleiro do jogo, sem as lâmpadas. A apresentação tem em conta, para casos em que o mapa tenha 
diferentes alturas, apresenta os cubos respectivos por baixo, de forma a que o tabuleiro esteja apresentavél.

== Exemplo de utilização :

>>>formaTab "aa" 0 0 
["<Transform translation='0 0 0'> <Shape USE=\"tile\"/> </Transform>","<Transform translation='1 0 0'> <Shape USE=\"tile\"/> </Transform>"]
-}

formaTab :: Linha -> Vx -> Vy -> Html
formaTab [] x y  = []
formaTab (h:t) x y = if ord h > 97
                     then ("<Transform translation='"++show x ++" "++show y++" "++show((ord h)-97)++"'> <Shape USE=\"tile\"/> </Transform>" ) : formaTab ((chr((ord h)-1)):t) x y  
                     else if ord h < 97 && ord h /= 96
                          then formaTab ((chr((ord h)+31)):t) x y 
                          else if ord h == 65 || ord h == 96 
                               then formaTab t (x+1) y
                               else ("<Transform translation='"++show x ++" "++show y++" "++show((ord h)-97)++"'> <Shape USE=\"tile\"/> </Transform>" ) : formaTab t (x+1) y

{- | A função formaTab2, é uma função que aplica de forma recursiva a função formaTab, precorrendo todas as linhas
do mapa, devolvendo um código html, com o tabuleiro completo, no entanto, sem as lâmpadas.  

== Exemplo de utilização :

>>>formaTab2 ["aa","aa"] 0 0 
["<Transform translation='0 0 0'> <Shape USE=\"tile\"/> </Transform>","<Transform translation='1 0 0'> <Shape USE=\"tile\"/> </Transform>",
"<Transform translation='0 1 0'> <Shape USE=\"tile\"/> </Transform>","<Transform translation='1 1 0'> <Shape USE=\"tile\"/> </Transform>"]
-}

formaTab2 :: Mapa -> Vx -> Vy -> Html
formaTab2 [] x y = []
formaTab2 (h:t) x y = (formaTab h x y) ++ (formaTab2 t x (y+1))

{- | A função formaRobo, recebe um Nivel, do qual retira se a posição do robo, e a sua respetiva altura. Desta forma, a função devolve como output, uma linha de código html
que apresenta o robô na posição inicial.

== Exemplo de utilização :

>>>formaRobo ["aAa","aAa","aAa","0 0 N","AADALDALAL"] 
"<Transform scale=\".3 .3 .3\" def=\"robot\" translation='0 0 1' rotation='1 0 0 0'>"
-}

formaRobo :: Nivel -> LinhaHtml
formaRobo [] = []
formaRobo l = "<Transform scale=\".3 .3 .3\" def=\"robot\" translation='"++(init(last(init l)))++show ((conve(posicao mapa (xponto l) (yponto l)))+1)++"' rotation='"++formaOrient (last(init l)) ++"'>"
         where mapa = reverse (init ( init l))

{- | A função formaOrient, recebe as Coordenadas da posição inical do robô, e retira a orientação do robô. 
Desta forma para cada orientação, faz corresponder uma porção de código html que faz orientar o robô em 3D.  

== Exemplo de utilização :

>>>formaRobo "0 0 N"
"1 0 0 0"
-}

formaOrient :: Coordenadas -> LinhaHtml
formaOrient l | orient == 'N' = "1 0 0 0"
              | orient == 'S' = "1 0 0 3.14"
              | orient == 'O' = "0 0 1 1.57"
              | orient == 'E' = "1 1 0 3.14" 
         where orient = (last l)

{- | A função formaRotacao, recebe as Coordenadas da posição inical do robô, e retira a orientação do robô. 
Desta forma para cada orientação, faz corresponder uma porção de código html que faz orientar o robô em 3D.  

== Exemplo de utilização :

>>>formaRotacao "0 0 N"
"1 0 0 0"
-}

formaRotacao :: Nivel -> Comandos -> Orientacao -> LinhaHtml
formaRotacao l [] s = []
formaRotacao l (h:t) s | h == 'E' && s == 'N' = "0 0 1 1.57"++"  "++formaRotacao l t 'O' 
                       | h == 'E' && s == 'S' = "1 1 0 3.14"++"  "++formaRotacao l t 'E'
                       | h == 'E' && s == 'E' = "1 0 0 0"++"  "++formaRotacao l t 'N'
                       | h == 'E' && s == 'O' = "1 0 0 3.14"++"  "++formaRotacao l t 'S'
                       | h == 'D' && s == 'N' = "1 1 0 3.14"++"  "++formaRotacao l t 'E'
                       | h == 'D' && s == 'S' = "0 0 1 1.57"++"  "++formaRotacao l t 'O'
                       | h == 'D' && s == 'E' = "1 0 0 3.14"++"  "++formaRotacao l t 'S'
                       | h == 'D' && s == 'O' = "1 0 0 0"++"  "++formaRotacao l t 'N'
                       | otherwise = formaOrient (init(last(init l)) ++ [s])++"  "++ formaRotacao l t s

{- | A função formaCam, recebe o Nivel, os comandos, coordenadas x, y e z da posição inical do robô, a orietação do robô e a String
das coordenadas das lâmpadas. A partir destes argumentos, a função vai ler recursivamente os comandos, aplicando as devias alterações 
nas coordenadas, tendo em atenção se caso salta para uma posição mais alta ou mais baixa. Caso o comando for 'L', as coordenadas em que o robô se situa, 
passam para a String das coordenadas das lampadas.
 
== Exemplo de utilização :

>>>formaCam ["aaa","aaa","aAa","0 0 N","ADAL"] (last ["aaa","aaa","aAa","0 0 N","ADAL"]) 0 0 1 'N' []
"0 1 1 0 1 1 1 1 1 1 1 1 R 1 1 1 "
-}

formaCam :: Nivel -> Comandos -> Vx-> Vy -> Vz -> Orientacao -> CoordLampadas -> LinhaHtml
formaCam l [] x y z s f = f
formaCam l (h:t) x y z s f | h == 'A' && s == 'N' = (show x++" "++show (y+1)++" "++show z ) ++" "++formaCam l t x (y+1) z s f
                           | h == 'A' && s == 'S' = (show x++" "++show (y-1)++" "++show z ) ++" "++formaCam l t x (y-1) z s f
                           | h == 'A' && s == 'E' = (show (x+1)++" "++show y++" "++show z ) ++" "++formaCam l t (x+1) y z s f
                           | h == 'A' && s == 'O' = (show (x-1)++" "++show y++" "++show z ) ++" "++formaCam l t (x-1) y z s f
                           | h == 'E' && s == 'N' = coord ++" "++formaCam l t x y z 'O' f
                           | h == 'E' && s == 'S' = coord ++" "++formaCam l t x y z 'E' f
                           | h == 'E' && s == 'E' = coord ++" "++formaCam l t x y z 'N' f
                           | h == 'E' && s == 'O' = coord ++" "++formaCam l t x y z 'S' f
                           | h == 'D' && s == 'N' = coord ++" "++formaCam l t x y z 'E' f
                           | h == 'D' && s == 'S' = coord ++" "++formaCam l t x y z 'O' f
                           | h == 'D' && s == 'E' = coord ++" "++formaCam l t x y z 'S' f
                           | h == 'D' && s == 'O' = coord ++" "++formaCam l t x y z 'N' f
                           | h == 'S' && s == 'N' && sobe = (show x++" "++show (y+1)++" "++show (z+1) ) ++" "++formaCam l t x (y+1) (z+1) s f
                           | h == 'S' && s == 'S' && sobe = (show x++" "++show (y-1)++" "++show (z+1) ) ++" "++formaCam l t x (y-1) (z+1) s f
                           | h == 'S' && s == 'E' && sobe = (show (x+1)++" "++show y++" "++show (z+1) ) ++" "++formaCam l t (x+1) y (z+1) s f
                           | h == 'S' && s == 'O' && sobe = (show (x-1)++" "++show y++" "++show (z+1) ) ++" "++formaCam l t (x-1) y (z+1) s f
                           | h == 'S' && s == 'N' && desce = (show x++" "++show (y+1)++" "++show (z-1) ) ++" "++formaCam l t x (y+1) (z-1) s f
                           | h == 'S' && s == 'S' && desce = (show x++" "++show (y-1)++" "++show (z-1) ) ++" "++formaCam l t x (y-1) (z-1) s f
                           | h == 'S' && s == 'E' && desce = (show (x+1)++" "++show y++" "++show (z-1) ) ++" "++formaCam l t (x+1) y (z-1) s f
                           | h == 'S' && s == 'O' && desce = (show (x-1)++" "++show y++" "++show (z-1) ) ++" "++formaCam l t (x-1) y (z-1) s f
                           | otherwise = (show x++" "++show y++" "++show z ) ++" "++ formaCam l t x y z s (f ++ ("R "++show x++" "++show y++" "++show z++" " ))
                   where sobe  = trans(posicaoSe mapa x y s) > trans(posicao mapa x y )
                         desce = succ (trans(posicaoSe mapa x y s)) <= trans(posicao mapa x y )
                         mapa  = reverse (init ( init l))
                         coord = (show x++" "++show y++" "++show z )


{- | A função trans, recebe uma posição e tranforma, caso for um caratér entre 'A' e 'Z', em caractéres entre 'a' e 'z'. Esta função permite que os caractéres de 'A' até 'Z', 
sejam comparáveis com os caractéres de 'a' até 'z'. 

== Exemplo de utilização :

>>>trans 'A' 
'a'
-}

trans :: Posicao -> Posicao   
trans x = if ord x < 97  then chr ((ord x) + 32) else x 

{- | A função retira, recebe uma String de uma linha de código html, da função formaCam, e retira a parte referente as coordenadas das lâmpadas.

== Exemplo de utilização :

>>>retira "0 1 1 0 1 1 1 1 1 1 1 1 R 1 1 1 " 
"0 1 1 0 1 1 1 1 1 1 1 1 "
-}

retira :: LinhaHtml -> LinhaHtml
retira [] = []
retira (h:t) = if h == 'R' then [] else h: retira t

{- | A função coordLuz, recebe uma lista de uma String das coordenadas das lâmpadas, repartida em cada caractér, devido a função words, 
e retira os caratéres 'R', e tranforma as coordenadas, numa lista de Int.

== Exemplo de utilização :

>>>coordLuz ["R","1","1","1"]
[1,1,1]
-}

coordLuz :: [CoordLampadas] -> [Int]
coordLuz [] = []
coordLuz (h:t) = if h == "R" then coordLuz t else (strInt h):coordLuz t

{- | A função formaLamp, recebe uma lista de Int, proveniente da função coordLuz, e um Int, servindo de acumulador. A função devolve um código
html, que permite a formação dos cubos que representam as lâmpadas.

== Exemplo de utilização :

>>>formaLamp [1,1,1] 1
["<Shape DEF=\"tileL1\">","<Appearance>","<Material def=\"corLam1\" diffuseColor='0 0 1.0'/>","</Appearance>",
"<Box size='.98 .98 .98'/>","</Shape>","<Transform translation='1 1 0'> <Shape USE=\"tileL1\"/> </Transform>"]

-}

formaLamp :: [Int]-> Int -> Html
formaLamp [] x = []
formaLamp (a:b:c:d) x = ["<Shape DEF=\"tileL"++show x++"\">",
                         "<Appearance>",
                         "<Material def=\"corLam"++show x++"\" diffuseColor='0 0 1.0'/>",
                         "</Appearance>",
                         "<Box size='.98 .98 .98'/>",
                         "</Shape>",
                         "<Transform translation='"++show a ++" "++show b++" "++show (c-1)++"'> <Shape USE=\"tileL"++show x++"\"/> </Transform>"] ++ formaLamp d (x+1)
                               
{- | A função formaLuz, recebe duas listas dos Comandos, dois Int, servindo como acumuladores. Esta função devolve um código html, que permite, com auxilio da função temp2, 
para calular o instante em que a lâmapada liga, a animação 3D em que o robô liga as lâmpadas. O acumulador x, serve para cada lâmpada que surge, criar um DEF diferente, tornando
as lâmpadas independentes. O acumulador y, serve para indicar em que altura é aplicado o comando 'L'.

== Exemplo de utilização :

>>>formaLuz "ADAL" "ADAL" 1 0 
["<PositionInterpolator DEF=\"corL1\" key=\"0 0.75 1.0 1\" keyValue=\"0.57 0.57 0.57  0.57 0.57 0.57  1 1 0  1 1 0\"> </PositionInterpolator>   ",
"<Route fromNode=\"time\" fromField =\"fraction_changed\" toNode=\"corL1\" toField=\"set_fraction\"> </Route> ",
"\t<Route fromNode=\"corL1\" fromField =\"value_changed\" toNode=\"corLam1\" toField=\"diffuseColor\"> </Route>  ",""]
-}

formaLuz :: Comandos -> Comandos -> Int -> Int -> Html
formaLuz l [] x y = []
formaLuz l (h:t) x y = if h == 'L'
                       then ["<PositionInterpolator DEF=\"corL"++ show x ++"\" key=\""++"0 "++temp2 l l y ++" 1"++"\" keyValue=\""++ "0.57 0.57 0.57  0.57 0.57 0.57  1 1 0  1 1 0" ++"\"> </PositionInterpolator>   ",
                             "<Route fromNode=\"time\" fromField =\"fraction_changed\" toNode=\"corL"++ show x ++"\" toField=\"set_fraction\"> </Route> ",
                             "\t<Route fromNode=\"corL"++ show x ++"\" fromField =\"value_changed\" toNode=\"corLam"++ show x ++"\" toField=\"diffuseColor\"> </Route>  ",
                             ""] ++ formaLuz l t (x+1) (y+1)
                       else formaLuz l t x (y+1)
                      

{- | A função temp recebe duas String e um Int, e devolve uma porção de código html. Esta porção é referente aos intervalos de tempo de cada comando, ou seja,
admitindo 1 como o tempo de execução do nível, divindindo pelo numero de comandos, obtemos os intervalos. 

== Exemplo de utilização :

>>>temp "ADAL" "ADAL" 1 
"0.25 0.5 0.75 1.0 "
-}  

temp :: Comandos -> Comandos -> Int -> LinhaHtml
temp [] l x = []
temp (h:t) l x = show (divid x (length l))++" "++ temp t l (x+1) 

{- | A função temp2 recebe duas String e um Int, e devolve uma porção de código html. Esta porção é referente um preciso intrevalo de tempo, ou seja,
tendo vários comandos, o valor de x vai ser o número de coordenadas até lá aplicadas. Assim a função calcula esse instante e o o próximo apenas.

== Exemplo de utilização :

>>>temp2 "ADAL" "ADAL" 2 
"0.5 0.75"
-}  


temp2 :: Comandos -> Comandos -> Int -> LinhaHtml
temp2 l (h:t) x = if h == 'L' then show (divid x (length l)) ++" "++show (divid (x+1) (length l)) else temp2 l t x 


{- | A função divid recebe dois Int, e devolve um Float. Esta função permite apresentar em casa decimais, as divisões necessarias na função temp e temp2.

== Exemplo de utilização :

>>>divid 1 2  
0.5
-}  

divid :: Int -> Int -> Float
divid a b = (fromIntegral a) / (fromIntegral b)

{- | A função formaRota, recebe o Nivel, e aplica a função temp, que define os intervalos de tempo, a função formaCam, que apresenta a sequência de movimentos do robô, 
a função formaRotacao, que vai dando a sequências de rotações do robô, e a função formaLuz, que vai dar as instâncias em que cada luz se liga. Devolve assim, um código html, 
que permite a animação do robô e das lâmpadas ao longo do nível.

== Exemplo de utilização :

>>>formaRota ["aaa","aAa","aaa","0 0 N","ADAL"]
["\t<timeSensor DEF=\"time\" cycleInterval=\"4\" loop=\"true\"> </timeSensor>","",
"<PositionInterpolator DEF=\"move\" key=\"0 0.25 0.5 0.75 1.0\" keyValue=\"0 0 1 0 1 1 0 1 1 1 1 1 1 1 1 \"> </PositionInterpolator>       ",
"<Route fromNode=\"time\" fromField =\"fraction_changed\" toNode=\"move\" toField=\"set_fraction\"> </Route> ",
"\t<Route fromNode=\"move\" fromField =\"value_changed\" toNode=\"robot\" toField=\"translation\"> </Route>     ",
"",
"<orientationInterpolator DEF=\"moveR\" key=\"0 0.25 0.5 0.75 1.0\" keyValue=\"1 0 0 0  1 0 0 0  1 1 0 3.14  1 1 0 3.14  1 1 0 3.14\"> </orientationInterpolator> ",
"<Route fromNode=\"time\" fromField=\"fraction_changed\" toNode=\"moveR\" toField=\"set_fraction\"> </Route>",
"<Route fromNode=\"moveR\" fromField=\"value_changed\" toNode=\"robot\" toField=\"rotation\"> </Route>   ",
"",
"<PositionInterpolator DEF=\"corL1\" key=\"0 0.75 1.0 1\" keyValue=\"0.57 0.57 0.57  0.57 0.57 0.57  1 1 0  1 1 0\"> </PositionInterpolator>   ",
"<Route fromNode=\"time\" fromField =\"fraction_changed\" toNode=\"corL1\" toField=\"set_fraction\"> </Route> ",
"\t<Route fromNode=\"corL1\" fromField =\"value_changed\" toNode=\"corLam1\" toField=\"diffuseColor\"> </Route>  ",""]
-}

formaRota :: Nivel -> Html
formaRota l = ["\t<timeSensor DEF=\"time\" cycleInterval=\""++show(length( last l))++"\" loop=\"true\"> </timeSensor>",
                    "",
                    "<PositionInterpolator DEF=\"move\" key=\""++"0"++" "++init(temp (last l) (last l) 1 )++"\" keyValue=\""++posiI++" "++retira(formaCam l (last l) (xponto l) (yponto l) valorZ (last (last(init l))) [])++"\"> </PositionInterpolator>       ",
                    "<Route fromNode=\"time\" fromField =\"fraction_changed\" toNode=\"move\" toField=\"set_fraction\"> </Route> ",
                    "\t<Route fromNode=\"move\" fromField =\"value_changed\" toNode=\"robot\" toField=\"translation\"> </Route>     ",
                    "",
                    "<orientationInterpolator DEF=\"moveR\" key=\""++"0"++" "++init(temp (last l) (last l) 1 )++"\" keyValue=\""++orientI++"  "++init (init(formaRotacao l (last l) (last(last(init l))) ))++"\"> </orientationInterpolator> ",
                    "<Route fromNode=\"time\" fromField=\"fraction_changed\" toNode=\"moveR\" toField=\"set_fraction\"> </Route>",
                    "<Route fromNode=\"moveR\" fromField=\"value_changed\" toNode=\"robot\" toField=\"rotation\"> </Route>   ",
                    ""] ++ formaLuz (last l) (last l) 1 0
   where valorZ  = ((conve(posicao mapa (xponto l) (yponto l)))+1)
         posiI   = (init(last(init l)))++show (valorZ)
         orientI = formaOrient (last(init l)) 
         mapa    = reverse (init ( init l))


{- | A função conve recebe um Char e converte num Int. Esta função permite determinar a altura das posições, devolvendo os valores da coordenada z.

== Exemplo de utilização :

>>>conve 'A' 
97
>>>conve 'b'
98
-}  

conve :: Posicao -> Int  
conve x = if ord x > 96  then ord x -97  else (ord x + 32) - 97 

{- | A função posicao, recebe o Mapa, e dois Int, que representam as coordenadas x e y. Esta função dá-nos o local exacto do robô no mapa, 
devolvendo assim o Char em que se localiza.

== Exemplo de utilização :

>>>posicao ["aBac","aAca","aabb","2 1 N","ASDAA"]
"c"

-}

posicao :: Mapa -> Vx -> Vy -> Posicao
posicao [] x y = ' '
posicao l x y = head (drop x (head(drop y l))) 

{- | A função posicaoSe, recebe o Mapa, dois Int, que representam as coordenadas x e y, e um Char, ou seja, a orientação do robô. 
Esta função dá-nos o local da posição seguinte, consoante a orientação do robô. Devolve assim o Char da próxima posição.

== Exemplo de utilização :

>>>posicao ["aBac","aAca","aabb","2 1 N","ASDAA"]
"a"

-}

posicaoSe :: Mapa -> Vx -> Vy -> Orientacao -> Posicao
posicaoSe l x y s | s == 'N' = posicao l x (y+1) 
                  | s == 'S' = posicao l x (y-1)
                  | s == 'E' = posicao l (x+1) y 
                  | s == 'O' = posicao l (x-1) y 

{- | A função yponto recebe a String do Nível, e calcula a coordenada Y.

== Exemplo de utilização :

>>>xponto  ["aaca","abba","adaa","0 1 N","ASDAA"] 
1
-}  

yponto :: [String] -> Int
yponto l = strInt (ajuda5 (head(ult2)))
      where ult2 = drop ((length l) - 2) l

{- | A função xponto recebe a String do Nível, e calcula a coordenada X.

== Exemplo de utilização :

>>>xponto  ["aaca","abba","adaa","0 1 N","ASDAA"] 
0
-}  

xponto :: [String] -> Int
xponto l = strInt (ajuda3 (head(ult2)))
      where ult2 = drop ((length l) - 2) l

{- | A função ajuda3 recebe uma String, e devolve os primeiros algarismos que encontrar. Esta função auxiliar tem como objectivo, retirar 
das Coordenadas, o valor de X.

== Exemplo de utilização :

>>>ajuda3  "0 1 N"
"0"
-}
ajuda3 :: String -> String
ajuda3 [] = [] 
ajuda3 (h:t) = if isNumber h  then h: ajuda3 t  else []

{- | A função ajuda5 recebe uma String, e retira os primeiros algarismos que encontrar, e devolve os próximos algarismos. Esta função auxiliar tem como objectivo, retirar 
das Coordenadas, o valor de Y.

== Exemplo de utilização :

>>>ajuda5  "0 1 N"
"1"
-}

ajuda5 :: String -> String 
ajuda5 (h:t) = if isNumber h then ajuda5 t 
               else if h == ' ' then ajuda3 t 
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
converte _ [] = 0 
converte e (x:xs) = x*10^e + converte (e+1) xs

-- fim