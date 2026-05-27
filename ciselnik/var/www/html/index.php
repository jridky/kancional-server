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

#number, #verse, #psalm, #songbook {
   margin: 0px;
   padding: 0px;
   text-align: center;
   align-items: center;
   justify-content: center;
   overflow: hidden;
   display: none;
}

#number, #verse, #songbook{
   height: 50%;
   line-height: 1em;
}

#number{
  font-size: 50em; /*25vw;*/
  letter-spacing: 100px;
  text-indent: 100px;
}

#verse, #songbook{
  font-size: 15vw;
  height: 25%;
}

#psalm{
  font-size: 10em;
  height: 100%;
}

.centered {
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
}

p {
  margin: 0px;
  padding: 0px;
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
</div>
<div id="verse">
</div>
<div id="songbook">
</div>
<div id="psalm">
<div class="center">
</div>
</div>
<div id="add" class="centered">
<img src="kancional.png">
<br><br>
<img src="google.png"> <img src="apple.png">
</div>
</body>
<script>
var screen = true, timeout = false, socket = false;
$(function(){
    $("#number").css("color","white");
    checkSocket();
    setInterval(checkSocket, 1800);
});

function checkSocket(){
    if(socket != false){
        if(socket.readyState != WebSocket.CLOSED){
            return;
        }
    }
    socket = new WebSocket('ws://kancional.local:2020');
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

function fitText(el, startSize) {
    el.css("font-size", startSize);
    var inner = el.children().first();
    while (inner.outerHeight() > el.innerHeight() || inner.outerWidth() > el.innerWidth()) {
        var value = parseInt(el.css("font-size")) - 10;
        if (value <= 0) break;
        el.css("font-size", value + "px");
    }
}


function displayValue(answer){
    if(answer.psalm == "" && (answer.verseText == undefined || answer.verseText == "")){
        $("#number").html("<div>" + answer.song + "</div>");
        if(answer.verse != "" && answer.verse != "0"){
            if(isFinite(answer.verse)){
                    $("#verse").html(answer.verse+". sloka");
            } else {
                    $("#verse").html(answer.verse);
            }
            $("#number").css("height", "50%");
            if(answer.songbook){
                $("#verse").css("height", "25%");
                $("#songbook").css("height", "25%");
                $("#songbook").html("<div>" + answer.songbook + "</div>");
                $("#songbook").css("display","flex");
            } else {
                $("#verse").css("height", "50%");
                $("#songbook").html("");
                $("#songbook").hide();
            }
            $("#verse").css("display","flex");
        } else {
            $("#verse").html("");
            $("#verse").hide();
            if(answer.songbook){
                $("#songbook").css("height", "50%");
                $("#number").css("height", "50%");
                $("#songbook").html("<div>" + answer.songbook + "</div>");
                $("#songbook").css("display","flex");
            } else {
                $("#number").css("height", "100%");
                $("#songbook").html("");
                $("#songbook").hide();
            }
        }
        $("#psalm, #add").hide();
        $("#number").css("display","flex");
        fitText($("#songbook"), "15vw");
        fitText($("#number"), "50em");
    } else {
        $("#psalm .center").html((answer.psalm != ""?answer.psalm:answer.verseText));
        $("#number, #verse, #add, #songbook").hide();
        $("#psalm").css("display","flex");
        fitText($("#psalm"), "30em");
    }

    if(jQuery.isEmptyObject(answer)){
        $("#psalm, #verse, #number, #songbook").hide();
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

