package WebController;

use strict;
use warnings 'all';

use Library::Template;

sub new {
    my $class = shift;
    my $this = {
        _baseDirectory => shift,
        _routesAddress => (),
        _routesControllers => (),
        _routesKey => (),
    };
    bless $this, $class;
    return $this;
}

sub index {
    my ($this, $data) = @_;

    print "Status: 200 OK\n";
    print "Content-type: text/html; charset=utf-8\n";
    print "\n";

    my $template = new Template;
    $template->load("View/index");
    $template->applyOptions(
        Variavel_1 => "Sucesso! 1",
        Teste => "Sucesso! 2",
        teste => "Sucesso! 3",
        variavel => "Sucesso! 4",
        a1 => "Sucesso! 5",
        [123] => "Sucesso! 6",
    );
    $template->render;

    return;
}
sub teste {
    my ($this, $data) = @_;

    print "Status: 200 OK\n";
    print "Content-type: text/html; charset=utf-8\n";
    print "\n";

    print "Teste\n";
    print $data;

    return;
}

sub sobre {
    my ($this, $data) = @_;

    print "Status: 200 OK\n";
    print "Content-type: text/html; charset=utf-8\n";
    print "\n";

    print "Sobre\n";
    print $data;

    return;
}

sub contato {
    my ($this, $data) = @_;

    print "Status: 200 OK\n";
    print "Content-type: text/html; charset=utf-8\n";
    print "\n";

    print "Contato\n";
    print $data;

    return;
}

sub erro404 {
    my ($this, $data) = @_;

    print "Status: 404 Not Found\n";
    print "Content-type: text/html; charset=utf-8\n";
    print "\n";

    print "Erro 404\n";
    print $data;

    return;
}

1;
