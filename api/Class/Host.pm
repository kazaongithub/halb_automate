package api::Class::Host;

use vars qw ($AUTOLOAD);
use Carp;

use api::Class::_Initializable;

@api::Class::Host::ISA = qw (api::Class::_Initializable);

sub _init
{
    my ($self, %args) = @_;

    $self->{_pkgs_dir}   = $args{pkgs_dir};
    $self->{_driver_sdk} = $args{driver_sdk};
    $self->{_server_sdk} = $args{server_sdk};
    $self->{_pek_file}   = $args{pek_file};
}

sub AUTOLOAD
{
    no strict 'refs';
    my ($self, $newval) = @_;

    # get.. method
    if ($AUTOLOAD =~ /.*::get(_\w+)/) {
        my $attr_name = $1;
        *{$AUTOLOAD} = sub { return $_[0]->{$attr_name} };
        return $self->{$attr_name}
    }

    # set.. method
    if ($AUTOLOAD =~ /.*::set(_\w+)/) {
        my $attr_name = $1;
        *{$AUTOLOAD} = sub { $_[0]->{$attr_name} = $_[1]; return; };
        $self->{$1} = $newval;
        return
    }

    croak "No such method: $AUTOLOAD";
}

sub DESTROY { }

1;
