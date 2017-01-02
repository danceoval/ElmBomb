// var jsonServer = require('json-server')

// // Returns an Express server
// var server = jsonServer.create()

// // Set default middlewares (logger, static, cors and no-cache)
// server.use(jsonServer.defaults())

// var router = jsonServer.router('db.json')
// server.use(router)

// console.log('Listening at 4000')
// server.listen(4000)

var express = require('express');
var app = express();
var db = require('./db.json');

// MIDDLEWARE

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.use(function (err, req, res, next) {
    console.error(err);
    res.status(500).send(err.message);
});


// ROUTES

app.get('/', function(req, res, next) {
  var questions = db.questions;
  var shuffled = shuffle(questions).slice(0, 12)
  res.setHeader('Content-Type', 'application/json');
  res.send(shuffled)
})


// UTILS

function swap(idx, arr) {
  var random = Math.floor(Math.random() * arr.length);
  var placeholder = arr[idx]
  arr[idx] = arr[random];
  arr[random] = placeholder;
}

function shuffle(deck) {
  for(var i = 0; i < deck.length; i++) {
    swap(i, deck)
  }
  return deck;
}

// SERVER

var server = app.listen(4000, function(){
  console.log('listening on port 4000');
});