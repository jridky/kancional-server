
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="jquery-3.4.1.min.js"></script>
<style>
html, body{
   background: black;
   width: 100%;
   height: 100%;
   overflow: hidden;
   color: white;
   cursor: none;
   font-family: Arial;
   padding: 0px;
   margin: 0px;
}

#number, #verse, #psalm{
   margin: 0px;
   padding: 0px;
   text-align: center;
}

#number, #verse{
   height: 50%;
   line-height: 1em;
   display: none;
}

#number{
  font-size: 50em; /*25vw;*/
  letter-spacing: 100px;
  text-indent: 100px;
}

#verse{
  font-size: 15vw;
}

#psalm{
  font-size: 10em;
  height: 100%;
}

.centered{
  position: relative;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
}

img {
  display: inline-block;
  width: 25%;
  margin: 5px auto;
#  filter: saturate(80%) brigntness(60%) contrast(60%);
}

#zero{
  height: 100%;
  width: 0px;
  float: left;
}
</style>
</head>
<body>
<div id="zero"></div>
<div id="number">
<div class="centered"></div>
</div>
<div id="verse">
 <div class="centered">
 </div>
</div>
<div id="psalm">
<div class="centered">
</div>
</div>
<div id="add" class="centered">
<img src="kancional.png">
<br><br>
<img src="google.png"> <img src="apple.png">
</div>
</body>

<script>
var time = 0, screen = true, timeout = false, socket = false;
$(function(){
	$("#number").css("color","red");
	checkSocket();
	setInterval(checkSocket, 1800);
});

function checkSocket(){
	if(socket != false){
		if(socket.readyState != WebSocket.CLOSED){
			return;
		}
	}
	socket = new WebSocket('ws://localhost:2020');
	socket.addEventListener('message', getMessage, event);
}
		
function getMessage (event){
	try{
		var answer = JSON.parse(event.data);
		if(timeout != false){
			clearTimeout(timeout);
		}
		timeout = setTimeout(offScreen, 8800000);
		if(!screen){
			screen = true;
			$.ajax({url:"/onscreen.php"});
		}
		displayValue(answer);
	}catch(error){
		offScreen();
	}
}

function offScreen(){
	if(screen){
		screen = false;
		clearTimeout(timeout);
		timeout = false;
		$.ajax({url:"/offscreen.php"});
	} else {
		clearTimeout(timeout);
		timeout = false;
	}
}

function displayValue(answer){
	if(time < parseInt(answer.time)){
		time = parseInt(answer.time);
		if(answer.psalm == ""){
			$("#number .centered").html(answer.song);
			if(answer.verse != "" && answer.verse != "0"){
				$("#verse .centered").html(answer.verse+". sloka");
				$("#number").css("height", "50%");
				$("#verse").show();
			}else{
				$("#verse .centered").html("");
				$("#verse").hide();
				$("#number").css("height", "100%");
			}
			$("#add").hide();
			$("#number").show();
			$("#number").css("font-size", "50em");
			while( $("#number").innerHeight() < $("#number").prop("scrollHeight")  || $("#number").innerWidth() < $("#number").prop("scrollWidth") ){
				var value = parseInt($("#number").css("font-size"));
				value = value - 10;
				$("#number").css("font-size", value+"px");
			}
			$("#number").show();
			$("#psalm").hide();
		}else{
			$("#psalm .centered").html(answer.psalm);
			$("#number, #verse, #add").hide();
			$("#psalm").show();
			$("#psalm").css("font-size", "30em");
			while( $("#psalm").innerHeight() < $("#psalm").prop("scrollHeight") ){
				var value = parseInt($("#psalm").css("font-size"));
				value = value - 10;
				$("#psalm").css("font-size", value+"px");
			}
		}
	}
	if(jQuery.isEmptyObject(answer)){
		$("#psalm, #verse, #number").hide();
		$("#add").show();
		clearTimeout(timeout);
		timeout = false;
		setTimeout(function(){
			if(timeout == false){
				screen = false;
				$.ajax({url:"/offscreen.php"});
			}
		}, 8000);
	}
}
</script>
</html>

