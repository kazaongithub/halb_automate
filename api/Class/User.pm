package api::Class::User;

use vars qw ($AUTOLOAD);
use Carp;

use api::Class::_Initializable;
@api::Class::User::ISA = qw (api::Class::_Initializable);

sub _init
{
    my ($self, %args) = @_;
    
    $self->{_user_name} = $args{user_name};
    $self->{_password}  = $args{password};
    $self->{_user_type} = $args{user_type};
    $self->{_user_id}   = undef;
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
