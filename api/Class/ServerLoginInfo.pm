package api::Class::ServerLoginInfo;

use vars qw ($AUTOLOAD);
use Carp;

use api::Class::_Initializable;

@api::Class::ServerLoginInfo::ISA = qw (api::Class::_Initializable);

our $attrs = [
    'username',
    'password',
    'PARTITION',
];

sub _init
{
    my ($self, %args) = @_;
    
    $self->{_login_info_config_name} = $args{login_info_config_name} | 'loginInfo'; 
    $self->{_username}               = $args{username} | 'app_user';
    $self->{_password}               = $args{password} | 'user123';
    $self->{_PARTITION}              = $args{PARTITION};
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
