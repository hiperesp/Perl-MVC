package Template;

use strict;
use warnings 'all';

use File::Slurp;

sub new {
    my $class = shift;
    my $this = {
        _template => "<!DOCTYPE html><html><head></head><body><h1>Default Template</h1><hr><p>Default Template</p></body></html>",
    };
    bless $this, $class;
    return $this;
}

sub load {
    my ($this, $templateLocation) = @_;

    $this->{_template} = read_file($templateLocation.".html");

    return;
}

sub applyOptions {
    my ($this, %templateOptions) = @_;

    while(my($key,$value) = each %templateOptions ) {
        $this->{_template} =~ s/\<var:$key\/?\>/$value/g;
    }

    return;
}

sub render {
    my ($this) = @_;

    print $this->{_template};

    return;
}

1;
