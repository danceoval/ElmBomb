var express = require('express');
var app = express();
var db = require('./db.json');
var path = require('path');

// MIDDLEWARE

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.use(express.static(__dirname + 'dist/static'));

app.use(function (err, req, res, next) {
    console.error(err);
    res.status(500).send(err.message);
});


// ROUTES

app.get('/', function(req, res, next) {
  var questions = db.questions;
  var shuffled = shuffle(questions).slice(0, 12)
  var ordered = order(shuffled) 
  var prized = setPrize(ordered)
  res.setHeader('Content-Type', 'application/json');
  var indexPath = path.join(__dirname + "/dist/index.html")
  //res.send(prized)
  res.render(path.resolve(indexPath))
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

function setPrize(questions) {
  //1-5 gems, 0 = bomb, 6 = switch
  var prized = [];
  for(var i = 0; i < questions.length; i++) {
    var el = questions[i]
    var prize = Math.floor(Math.random() * 7)
    el["prize"] = prize;
    prized.push(el)
  }
  return prized
}

function order(questions) {
  var ordered = []
  for(var i = 0; i < questions.length; i++) {
    var el = questions[i]
    el["order"] = i;
    ordered.push(el)
  }
  return ordered
}

// SERVER
var port = process.env.PORT || 4000
var server = app.listen(port, function(){
  console.log('listening on port ', port);
});