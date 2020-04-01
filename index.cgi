#!A:\xampp\perl\bin\perl.exe
package Index;

use strict;
use warnings 'all';

use Library::Router;


my $router = new Router("/MVC%20-%20Perl/public_html");

$router->get("/", "Controller::WebController->index");
$router->get("/teste", "Controller::WebController->teste");
$router->get("/sobre", "Controller::WebController->sobre");
$router->get("/contato", "Controller::WebController->contato");
$router->error(404, "Controller::WebController->erro404");

$router->dispatch();



1;