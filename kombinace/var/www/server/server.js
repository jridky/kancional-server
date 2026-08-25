"use strict";

// Optional. You will see this name in eg. 'ps' or 'top' command
process.title = 'kancional-ws';

// Global constants
const fs = require('fs');
const path = require('path');
const passwd = "SET-YOUR-PASSWORD";
const md5 = require('md5');

const imagesDir = "/var/www/server/images";
const imageFile = path.join(imagesDir, "obrazek.webp");
if (!fs.existsSync(imagesDir)) {
    fs.mkdirSync(imagesDir);
}

// Port where we'll run the websocket server
var webSocketsServerPort = 2020;
// websocket and http servers
var webSocketServer = require('/var/www/server/node_modules/websocket').server;
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

    if (request.method === 'GET' && request.url.startsWith('/images/obrazek.webp')) {
        fs.readFile(imageFile, function(err, data) {
            if (err) {
                response.writeHead(404);
                response.end('Not found');
                return;
            }
            response.writeHead(200, {'Content-Type': 'image/webp'});
            response.end(data);
        });
        return;
    }

    fs.readFile(myFile, 'utf8', function (err, data){
        var d;
        if (err) {
            d = {};
        }else{
            try{
                var fields = JSON.parse(data);
                d = {song: fields.song, verse: fields.verse, source: fields.source, package: fields.package, psalm: fields.psalm, verseText: fields.verseText, time: fields.time, tv: tvStatus, songbook: fields.songbook};
                if (fields.time == "0"){
                    d = {};
                }
            }catch(e){
                console.log("Error parsing: " + data);
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
    httpServer: server,
    maxReceivedFrameSize: 10 * 1024 * 1024,
    maxReceivedMessageSize: 10 * 1024 * 1024
});

const myFile = "/var/www/server/number";
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
            try{
                var fields = JSON.parse(data);
                d = {song: fields.song, verse: fields.verse, source: fields.source, package: fields.package, psalm: fields.psalm, verseText: fields.verseText, time: fields.time, tv: tvStatus, songbook: fields.songbook};
                if (fields.time == "0"){
                    d = {};
                }
            }catch(e){
                console.log("Error parsing: " + data);
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
             try{
                var fields = JSON.parse(data);
                d = {song: fields.song, verse: fields.verse, source: fields.source, package: fields.package, psalm: fields.psalm, verseText: fields.verseText, time: fields.time, tv: tvStatus, songbook: fields.songbook};
                if (fields.time == "0"){
                    d = {};
                }
            }catch(e){
                console.log("Error parsing: " + data);
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
        if (message.type === 'binary') {
            fs.writeFile(imageFile, message.binaryData, function(err) {
                connection.sendUTF(err ? 'img_err' : 'img_ok');
            });
            return;
        }
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
                delete json['crc'];
                delete json['tv'];
                fs.writeFile(myFile, JSON.stringify(json), 'utf8', function(err){
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
