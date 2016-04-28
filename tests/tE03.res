<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<head>
<meta http-equiv="X-UA-Compatible" content="chrome=1" />
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<script type="text/javascript" src="http://www.x3dom.org/release/x3dom.js"></script>
<link rel="stylesheet" type="text/css" href="http://www.x3dom.org/release/x3dom.css"/>

<title>Hello World</title>

<style type="text/css">

x3d
{
right: 0px;
border: solid 4px rgb(240,240,240);
background: rgba(100, 100, 100, 0.8);
width:600px;
height:320px;
margin-right:1px;
float:left;



}


body
{
margin-left: 5em;
margin-top: 3em;
font-size: 90%;
font-family: sans-serif;
background-image: url('http://i.imgur.com/hn3xxdw.gif');
color: lightgray;
}

h1
{
color: rgb(240, 240, 240);
text-transform: uppercase;
margin-bottom: -14px;
}

p
{
color: lightgrey;
margin-bottom: 3em;
clear:right;
}

p.autores {
margin-bottom: 0.5em;
}


div.test {
clear:both;
margin-bottom: 3em;
}


</style>

</head>


<body bgcolor="#f an006400">
<h1>Animacao 3D</h1>
<p class="desc"> Deslocamento do robot as lampadas presentes no nivel</p>


<X3D xmlns="http://www.web3d.org/specifications/x3d-namespace" id="boxes">
<Scene>
<Shape DEF="tile">
<Appearance>
<Material diffuseColor='0.9411764705882353 0.9411764705882353 0.9411764705882353'/>
</Appearance>
<Box size='.98 .98 .98'/>
</Shape>
<Shape DEF="tileL">
<Appearance>
<Material def="corLam" diffuseColor='0 0 1.0'/>
</Appearance>
<Box size='.98 .98 .98'/>
</Shape>

<Shape DEF="tileL1">
<Appearance>
<Material def="corLam1" diffuseColor='0 0 1.0'/>
</Appearance>
<Box size='.98 .98 .98'/>
</Shape>
<Transform translation='0 2 4'> <Shape USE="tileL1"/> </Transform>
<Shape DEF="tileL2">
<Appearance>
<Material def="corLam2" diffuseColor='0 0 1.0'/>
</Appearance>
<Box size='.98 .98 .98'/>
</Shape>
<Transform translation='0 0 4'> <Shape USE="tileL2"/> </Transform>

<Transform translation='0 0 3'> <Shape USE="tile"/> </Transform>
<Transform translation='0 0 2'> <Shape USE="tile"/> </Transform>
<Transform translation='0 0 1'> <Shape USE="tile"/> </Transform>
<Transform translation='0 0 0'> <Shape USE="tile"/> </Transform>
<Transform translation='1 0 3'> <Shape USE="tile"/> </Transform>
<Transform translation='1 0 2'> <Shape USE="tile"/> </Transform>
<Transform translation='1 0 1'> <Shape USE="tile"/> </Transform>
<Transform translation='1 0 0'> <Shape USE="tile"/> </Transform>
<Transform translation='2 0 2'> <Shape USE="tile"/> </Transform>
<Transform translation='2 0 1'> <Shape USE="tile"/> </Transform>
<Transform translation='2 0 0'> <Shape USE="tile"/> </Transform>
<Transform translation='3 0 1'> <Shape USE="tile"/> </Transform>
<Transform translation='3 0 0'> <Shape USE="tile"/> </Transform>
<Transform translation='0 1 0'> <Shape USE="tile"/> </Transform>
<Transform translation='1 1 0'> <Shape USE="tile"/> </Transform>
<Transform translation='2 1 0'> <Shape USE="tile"/> </Transform>
<Transform translation='3 1 0'> <Shape USE="tile"/> </Transform>
<Transform translation='0 2 3'> <Shape USE="tile"/> </Transform>
<Transform translation='0 2 2'> <Shape USE="tile"/> </Transform>
<Transform translation='0 2 1'> <Shape USE="tile"/> </Transform>
<Transform translation='0 2 0'> <Shape USE="tile"/> </Transform>
<Transform translation='1 2 3'> <Shape USE="tile"/> </Transform>
<Transform translation='1 2 2'> <Shape USE="tile"/> </Transform>
<Transform translation='1 2 1'> <Shape USE="tile"/> </Transform>
<Transform translation='1 2 0'> <Shape USE="tile"/> </Transform>
<Transform translation='2 2 2'> <Shape USE="tile"/> </Transform>
<Transform translation='2 2 1'> <Shape USE="tile"/> </Transform>
<Transform translation='2 2 0'> <Shape USE="tile"/> </Transform>
<Transform translation='3 2 1'> <Shape USE="tile"/> </Transform>
<Transform translation='3 2 0'> <Shape USE="tile"/> </Transform>

<Transform scale=".3 .3 .3" def="robot" translation='0 1 1' rotation='1 1 0 3.14'>
<Shape>
<Appearance>
<Material diffuseColor='0.25 .25 .25'/>
</Appearance>
<Cone></Cone>
</Shape>
</Transform>


	<timeSensor DEF="time" cycleInterval="23" loop="true"> </timeSensor>

<PositionInterpolator DEF="move" key="0 4.347826e-2 8.695652e-2 0.13043478 0.17391305 0.2173913 0.26086956 0.3043478 0.3478261 0.39130434 0.4347826 0.47826087 0.5217391 0.5652174 0.6086956 0.65217394 0.6956522 0.73913044 0.7826087 0.82608694 0.8695652 0.9130435 0.95652175 1.0" keyValue="0 1 1 1 1 1 2 1 1 3 1 1 3 1 1 3 2 2 3 2 2 2 2 3 1 2 4 0 2 5 0 2 5 0 2 5 0 2 5 1 2 4 2 2 3 3 2 2 3 2 2 3 1 1 3 0 2 3 0 2 2 0 3 1 0 4 0 0 5 0 0 5 "> </PositionInterpolator>       
<Route fromNode="time" fromField ="fraction_changed" toNode="move" toField="set_fraction"> </Route> 
	<Route fromNode="move" fromField ="value_changed" toNode="robot" toField="translation"> </Route>     

<orientationInterpolator DEF="moveR" key="0 4.347826e-2 8.695652e-2 0.13043478 0.17391305 0.2173913 0.26086956 0.3043478 0.3478261 0.39130434 0.4347826 0.47826087 0.5217391 0.5652174 0.6086956 0.65217394 0.6956522 0.73913044 0.7826087 0.82608694 0.8695652 0.9130435 0.95652175 1.0" keyValue="1 1 0 3.14  1 1 0 3.14  1 1 0 3.14  1 1 0 3.14  1 0 0 0  1 0 0 0  0 0 1 1.57  0 0 1 1.57  0 0 1 1.57  0 0 1 1.57  0 0 1 1.57  1 0 0 0  1 1 0 3.14  1 1 0 3.14  1 1 0 3.14  1 1 0 3.14  1 0 0 3.14  1 0 0 3.14  1 0 0 3.14  0 0 1 1.57  0 0 1 1.57  0 0 1 1.57  0 0 1 1.57  0 0 1 1.57"> </orientationInterpolator> 
<Route fromNode="time" fromField="fraction_changed" toNode="moveR" toField="set_fraction"> </Route>
<Route fromNode="moveR" fromField="value_changed" toNode="robot" toField="rotation"> </Route>   

<PositionInterpolator DEF="corL1" key="0 0.39130434 0.4347826 1" keyValue="0.57 0.57 0.57  0.57 0.57 0.57  1 1 0  1 1 0"> </PositionInterpolator>   
<Route fromNode="time" fromField ="fraction_changed" toNode="corL1" toField="set_fraction"> </Route> 
	<Route fromNode="corL1" fromField ="value_changed" toNode="corLam1" toField="diffuseColor"> </Route>  

<PositionInterpolator DEF="corL2" key="0 0.95652175 1.0 1" keyValue="0.57 0.57 0.57  0.57 0.57 0.57  1 1 0  1 1 0"> </PositionInterpolator>   
<Route fromNode="time" fromField ="fraction_changed" toNode="corL2" toField="set_fraction"> </Route> 
	<Route fromNode="corL2" fromField ="value_changed" toNode="corLam2" toField="diffuseColor"> </Route>  


</Scene>
</X3D>
<div class="test">
</div>

<p class="autores">  a75372 <strong>Joao Reis</strong> | a74185 <strong>Ricardo Pereira</strong> </p>
<img src="http://i.imgur.com/QgYr5nj.png"/>


</body>
</html>

