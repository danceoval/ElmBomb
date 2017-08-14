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



app.use(function (err, req, res, next) {
    console.error(err);
    res.status(500).send(err.message);
});


app.use('/static', express.static('dist/static'))

// ROUTES

app.get('/questions', function(req, res, next) {
  var questions = db.questions;
  var shuffled = shuffle(questions).slice(0, 12)
  var ordered = order(shuffled) 
  res.setHeader('Content-Type', 'application/json');
  res.send(ordered)
})

app.get('/', function(req, res, next) {
  res.sendFile(path.join(__dirname+'/dist/index.html'));
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

app.listen(process.env.PORT || 4000, function(){
  console.log('listening on port 4000');
});