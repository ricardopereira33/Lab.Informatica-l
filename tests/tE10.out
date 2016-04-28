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
<Transform translation='3 0 0'> <Shape USE="tileL1"/> </Transform>

<Transform translation='0 0 0'> <Shape USE="tile"/> </Transform>
<Transform translation='1 0 0'> <Shape USE="tile"/> </Transform>
<Transform translation='2 0 0'> <Shape USE="tile"/> </Transform>
<Transform translation='0 1 1'> <Shape USE="tile"/> </Transform>
<Transform translation='0 1 0'> <Shape USE="tile"/> </Transform>
<Transform translation='1 1 0'> <Shape USE="tile"/> </Transform>
<Transform translation='2 1 0'> <Shape USE="tile"/> </Transform>
<Transform translation='3 1 0'> <Shape USE="tile"/> </Transform>

<Transform scale=".3 .3 .3" def="robot" translation='0 1 2' rotation='1 0 0 3.14'>
<Shape>
<Appearance>
<Material diffuseColor='0.25 .25 .25'/>
</Appearance>
<Cone></Cone>
</Shape>
</Transform>


	<timeSensor DEF="time" cycleInterval="6" loop="true"> </timeSensor>

<PositionInterpolator DEF="move" key="0 0.16666667 0.33333334 0.5 0.6666667 0.8333333 1.0" keyValue="0 1 2 0 0 1 0 0 1 1 0 1 2 0 1 3 0 1 3 0 1 "> </PositionInterpolator>       
<Route fromNode="time" fromField ="fraction_changed" toNode="move" toField="set_fraction"> </Route> 
	<Route fromNode="move" fromField ="value_changed" toNode="robot" toField="translation"> </Route>     

<orientationInterpolator DEF="moveR" key="0 0.16666667 0.33333334 0.5 0.6666667 0.8333333 1.0" keyValue="1 0 0 3.14  1 0 0 3.14  1 1 0 3.14  1 1 0 3.14  1 1 0 3.14  1 1 0 3.14  1 1 0 3.14"> </orientationInterpolator> 
<Route fromNode="time" fromField="fraction_changed" toNode="moveR" toField="set_fraction"> </Route>
<Route fromNode="moveR" fromField="value_changed" toNode="robot" toField="rotation"> </Route>   

<PositionInterpolator DEF="corL1" key="0 0.8333333 1.0 1" keyValue="0.57 0.57 0.57  0.57 0.57 0.57  1 1 0  1 1 0"> </PositionInterpolator>   
<Route fromNode="time" fromField ="fraction_changed" toNode="corL1" toField="set_fraction"> </Route> 
	<Route fromNode="corL1" fromField ="value_changed" toNode="corLam1" toField="diffuseColor"> </Route>  


</Scene>
</X3D>
<div class="test">
</div>

<p class="autores">  a75372 <strong>Joao Reis</strong> | a74185 <strong>Ricardo Pereira</strong> </p>
<img src="http://i.imgur.com/QgYr5nj.png"/>


</body>
</html>

