"use strict";

// Optional. You will see this name in eg. 'ps' or 'top' command
process.title = 'kancional-ws';

// Global constants
const fs = require('fs');
const passwd = "SET-YOUR-PASSWORD";
const md5 = require('md5');

// Port where we'll run the websocket server
var webSocketsServerPort = 2020;
// websocket and http servers
var webSocketServer = require('/var/www/html/node_modules/websocket').server;
var http = require('http');
/**
 * Global variables
 */
// list of currently connected clients (users)
var clients = new Set();
var tvStatus = true;
/**
 * HTTP server
 */
var server = http.createServer(function(request, response) {
    fs.readFile(myFile, 'utf8', function (err, data){
        var d;
        if (err) {
            d = {};
        }else{
            var fields = data.split(";");
            d = {song: fields[1], verse: fields[2], source: fields[3], package: fields[4], psalm: fields[5], time: fields[0], tv: tvStatus};
            if (fields[0] == "0"){
                d = {};
            }
        }
        var json = JSON.stringify(d);
        response.writeHead(200, {'Content-Type': 'text/html'});
        response.write(json);
        response.end();
    });
});

server.listen(webSocketsServerPort, function() {
    console.log((new Date()) + " Server is listening on port "
        + webSocketsServerPort);
});

/**
 * WebSocket server
 */
var wsServer = new webSocketServer({
    // WebSocket server is tied to a HTTP server. WebSocket
    // request is just an enhanced HTTP request. For more info
    // http://tools.ietf.org/html/rfc6455#page-6
    httpServer: server
});

const myFile = "/var/www/html/number";
let fsWait = false;

fs.watch(myFile, (event, filename) => {
    if(fsWait) return;
    fsWait = setTimeout(()=> {
        fsWait = false;
    }, 100);
    fs.readFile(myFile, 'utf8', function (err, data){
        var d;
        if (err) {
            d = {};
        }else{ 
            var fields = data.split(";");
            d = {song: fields[1], verse: fields[2], source: fields[3], package: fields[4], psalm: fields[5], time: fields[0], tv: tvStatus};
            if (fields[0] == "0"){
                d = {};
            }
        }
        var json = JSON.stringify(d);
        clients.forEach(function send(key, value, set){
            value.sendUTF(json);
        });
    });
});

// This callback function is called every time someone
// tries to connect to the WebSocket server
wsServer.on('request', function(request) {
    console.log((new Date()) + ' New connection from origin '
        + request.origin + ' - IP: ' + request.socket.remoteAddress + '.');
    var connection = request.accept(null, request.origin); 
    var ip = request.socket.remoteAddress, origin = request.origin;

    clients.add(connection);

    fs.readFile(myFile, 'utf8', function (err, data){
        var d;
        if (err) {
            d = {};
        }else{ 
            var fields = data.split(";");
            d = {song: fields[1], verse: fields[2], source: fields[3], package: fields[4], psalm: fields[5], time: fields[0], tv: tvStatus};
            if (fields[0] == "0"){
                d = {};
            }
        }
        var json = JSON.stringify(d);
        connection.sendUTF(json);
    });

    // user disconnected
    connection.on('close', function(connection) {
        console.log((new Date()) + ' Closing connection from origin ' + origin + ' - IP ' + ip + '.');
        // remove user from the list of connected clients
        clients.delete(connection);
    });

    // user sent some message
    connection.on('message', function(message) {
        if (message.type === 'utf8') { // accept only text
            // first message sent by user is their name
            var json = JSON.parse(message.utf8Data)
            if(json.crc === md5(`${origin}|${passwd}`)){
                connection.sendUTF("ok");
                if(json.tv === false){
                    tvStatus = json.tv;
                } else if(json.tv === true){
                    tvStatus = json.tv;
                }
                fs.writeFile(myFile, `${json.time};${json.song};${json.verse};${json.source};${json.package};${json.psalm}`, 'utf8', function(err){
                    if(err){ 
                        console.log(err);
                    }
                });
            } else {
                connection.sendUTF("no");
            }
        }
    });
});
