package Router;

use strict;
use warnings 'all';

use URI::Split qw( uri_split uri_join );

sub new {
    my $class = shift||0;
    my $this = {
        _baseDirectory => shift||"",
        _routesAddress => [],
        _routesControllers => [],
        _routesErrorType => [],
        _routesErrorControllers => [],
    };
    bless $this, $class;
    return $this;
}

sub get {
    my ($this, $route, $controller) = @_;

    push @{$this->{_routesControllers}}, $controller;
    push @{$this->{_routesAddress}}, $route;

    return $this;
}

sub error {
    my ($this, $route, $controller) = @_;

    push @{$this->{_routesErrorType}}, $route;
    push @{$this->{_routesErrorControllers}}, $controller;

    return $this;
}

sub print {
    my ($this) = @_;

    my $routesLength = @{$this->{_routesAddress}};
    for(my $i=0; $i<$routesLength; $i++) {
        my $rota = $this->{_routesAddress}[$i];
        my $controlador = $this->{_routesControllers}[$i];
        print "Rota: ".$this->{_baseDirectory}.$rota.", Controller: ".$controlador."\n";
    }

    return;
}

sub __dispatchRoute {
    my($this, $routeController) = @_;

    my @controllerPath = split /\-\>/, $routeController;
    my $classPath = $controllerPath[0];
    $classPath =~ s/::/\//;
    require $classPath.".pm";
    my @classPath = split /\//, $classPath;
    my $classPathLength = @classPath;
    my $className = $classPath[$classPathLength-1];
    my $methodName = $controllerPath[1];
    my $classInstance;
    if($className->can(new)) {
        $classInstance = $className->new();
    } else {
        $classInstance = $className;
    }
    if($className->can($methodName)) {
        $classInstance->$methodName("Data");
    } else {
        $this->__methodNotFound();
    }

    return;
}

sub dispatch {
    my($this) = @_;

    my $routesLength = @{$this->{_routesAddress}};
    for(my $routeIndex=0; $routeIndex<$routesLength; $routeIndex++) {
        my($scheme, $auth, $path, $query, $frag) = uri_split($ENV{REQUEST_URI});
        my $search = $path;
        my $in = $this->{_baseDirectory}.$this->{_routesAddress}[$routeIndex].'$';
        if($search =~ /$in/) {
            $this->__dispatchRoute($this->{_routesControllers}[$routeIndex]);
            return;
        }
    }

    my $routesErrorLength = @{$this->{_routesErrorType}};
    for(my $routeIndex=0; $routeIndex<$routesErrorLength; $routeIndex++) {
        if($this->{_routesErrorType}[$routeIndex]==404) {
            $this->__dispatchRoute($this->{_routesErrorControllers}[$routeIndex]);
            return;
        }
    }

    $this->__error404();

    return;
}

sub __error404 {
    my($this) = @_;

    print "Status: 404 Not Found\n";
    print "Content-type: text/html; charset=utf-8\n";
    print "\n";
    print "<!DOCTYPE html><html><head></head><body><h1>404 Not Found</h1><hr><p>404 Not Found</p></body></html>";

    return;
}

sub __methodNotFound {
    my($this) = @_;

    print "Status: 500 Internal Server Error\n";
    print "Content-type: text/html; charset=utf-8\n";
    print "\n";
    print "<!DOCTYPE html><html><head></head><body><h1>Method Not Found</h1><hr><p>Method Not Found</p></body></html>";

    return;
}

sub __printHeaders {
    my($this, $code) = @_;

    if(!$code) {
        $code = 200;
    }

    my $contentType = "text/plain";
    my $codeString = "";
    if($code==500) {
        $codeString = "500 Internal Server Error";
    } elsif($code==404) {
        $codeString = "404 Not Found";
    } elsif($code==200) {
        $codeString = "200 OK";
    }
    print "Status: ".$codeString."\n";
    print "Content-type: ".$contentType."; charset=utf-8\n";
    print "\n";

    return;
}

1;