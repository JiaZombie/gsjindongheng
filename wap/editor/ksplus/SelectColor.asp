﻿<script type="text/javascript"> 
varname = location.search.substr(1);
var varnames = varname.split('|');
varname = varnames[0];
varnamev = varnames[1];
var colors = '\
000000#000000#000033#000066#000099#0000CC#0000FF#003300#003333#003366#003399#0033CC#0033FF#006600#006633#006666#006699#0066CC#0066FF#\
333333#009900#009933#009966#009999#0099CC#0099FF#00CC00#00CC33#00CC66#00CC99#00CCCC#00CCFF#00FF00#00FF33#00FF66#00FF99#00FFCC#00FFFF#\
666666#330000#330033#330066#330099#3300CC#3300FF#333300#333333#333366#333399#3333CC#3333FF#336600#336633#336666#336699#3366CC#3366FF#\
999999#339900#339933#339966#339999#3399CC#3399FF#33CC00#33CC33#33CC66#33CC99#33CCCC#33CCFF#33FF00#33FF33#33FF66#33FF99#33FFCC#33FFFF#\
CCCCCC#660000#660033#660066#660099#6600CC#6600FF#663300#663333#663366#663399#6633CC#6633FF#666600#666633#666666#666699#6666CC#6666FF#\
FFFFFF#669900#669933#669966#669999#6699CC#6699FF#66CC00#66CC33#66CC66#66CC99#66CCCC#66CCFF#66FF00#66FF33#66FF66#66FF99#66FFCC#66FFFF#\
FF0000#990000#990033#990066#990099#9900CC#9900FF#993300#993333#993366#993399#9933CC#9933FF#996600#996633#996666#996699#9966CC#9966FF#\
00FF00#999900#999933#999966#999999#9999CC#9999FF#99CC00#99CC33#99CC66#99CC99#99CCCC#99CCFF#99FF00#99FF33#99FF66#99FF99#99FFCC#99FFFF#\
0000FF#CC0000#CC0033#CC0066#CC0099#CC00CC#CC00FF#CC3300#CC3333#CC3366#CC3399#CC33CC#CC33FF#CC6600#CC6633#CC6666#CC6699#CC66CC#CC66FF#\
FFFF00#CC9900#CC9933#CC9966#CC9999#CC99CC#CC99FF#CCCC00#CCCC33#CCCC66#CCCC99#CCCCCC#CCCCFF#CCFF00#CCFF33#CCFF66#CCFF99#CCFFCC#CCFFFF#\
00FFFF#FF0000#FF0033#FF0066#FF0099#FF00CC#FF00FF#FF3300#FF3333#FF3366#FF3399#FF33CC#FF33FF#FF6600#FF6633#FF6666#FF6699#FF66CC#FF66FF#\
FF00FF#FF9900#FF9933#FF9966#FF9999#FF99CC#FF99FF#FFCC00#FFCC33#FFCC66#FFCC99#FFCCCC#FFCCFF#FFFF00#FFFF33#FFFF66#FFFF99#FFFFCC#FFFFFF';
var colorarray = colors.split('#');
var setv = '';
function showcolors() {
	var s = '';
	for(c in colorarray) {
		s += '<em onmouseover="v(\'' + colorarray[c] + '\')" style="background-color:#' + colorarray[c] + '"></em>';
	}
	document.getElementById('colors').innerHTML = s;
}

function setvalue(obj) {
 parent.document.getElementById(varname).style.backgroundColor = setv;
 parent.document.getElementById(varnamev).value = setv;
 parent.closeWindow();
}
 
function v(v) {
	v = v != 'transparent' ? '#' + v : 'transparent';
	document.getElementById('p').style.backgroundColor = v;
	setv = v;
	document.getElementById('pv').innerHTML = v;
}
 
</script>
<style> 
body { margin:0px;background-color:#333; }
#h { padding:0;width:210px;height:15px;background-color:#CCC;overflow:hidden;}
#p { margin:0;display:block;float:left;font-size:0;width:140px;height:13px;background:#DDF0DF; }
#pv { margin:0;display:block;float:left;font-size:12px;width:58px;height:13px;overflow:hidden;text-align: right;font-style:normal;background:#DDF0DF; }
#colors { clear:both;width:209px; height:133px; }
#colors em, .trans { font-size:0;margin:1px 0 0 1px;width:10px;height:10px;float:left;cursor:pointer; }
.trans { background-color: #FFF; }
</style>
 
<body onmousedown="setvalue(document.getElementById('colorhex'))" scrolling="no">
<div id="h"><em id="p"></em><em id="pv"></em><em class="trans" onmouseover="v('transparent')" style="background-image:url('transcolor.gif')"></em></div>
<div id="colors"></div>
<script type="text/javascript"> 
showcolors();
try {document.getElementById('box').style.backgroundColor = cvalue;} catch(e) {}
</script>
</body>
