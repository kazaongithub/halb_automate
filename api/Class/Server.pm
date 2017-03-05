package api::Class::Server;

use vars qw ($AUTOLOAD);
use Carp;
use api::Class::_Initializable;
use api::Class::Cfm2Util;
use api::Class::ServerConfig;

@api::Class::Server::ISA = qw (
    api::Class::_Initializable
    api::Class::Cfm2Util
    api::Class::ServerConfig
);

sub _init
{
    my ($self, %args) = @_;

    $self->api::Class::Cfm2Util::_init(%args);
    $self->api::Class::ServerConfig::_init(%args);

    $self->{_user_name}       = $args{user_name};
    $self->{_user_pswd}       = $args{user_pswd};
    $self->{_prompt}          = $args{prompt};
    $self->{_sdk_path}        = $args{sdk_path};
    $self->{_sdk_dir}         = $args{sdk_dir};
    $self->{_sdk_software}    = $args{sdk_software};
    $self->{_sdk_apps}        = $args{sdk_apps};
    $self->{_server_dir}      = $args{server_dir};
    $self->{_server_pek_path} = $args{server_pek_path};
    $self->{_pkgs_dir}        = $args{pkgs_dir};
    $self->{_driver_sdk}      = $args{driver_sdk};
    $self->{_server_sdk}      = $args{server_sdk};

    $self->{_plain_log}       = $args{plain_log};
    $self->{_util_log}        = $args{util_log};
    $self->{_server_log}      = $args{server_log};

    $self->{_server_config}   = $args{server_config};

    $self->{_plain_tty}       = undef;
    $self->{_util_tty}        = undef;
    $self->{_server_tty}      = undef;
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
