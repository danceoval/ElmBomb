// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed 

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var port;

if (process.env.Port) {
	port = "http://localhost:" + process.env.PORT	
} else {
	port = "http://localhost:4000/";
}

Elm.Main.embed( document.getElementById( 'main' ) );
Elm.Main.ports.api.send(port);
