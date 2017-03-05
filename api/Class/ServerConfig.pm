package api::Class::ServerConfig;

use vars qw ($AUTOLOAD);
use Carp;

use api::Class::_Initializable;
use api::Class::SSLConfig;
use api::Class::ServerLoginInfo;

@api::Class::ServerConfig::ISA = qw (api::Class::_Initializable api::Class::SSLConfig api::Class::ServerLoginInfo);

our $attrs = [
    'hostname',
    'back_channel_ip',
    'main_channel_port', 
    'back_channel_port',
    'util_channel_port',
    'pek_path',
    'workers',        
    'polling_interval',
    'log_level',
    'CriticalAlertScript',
    'reconnect_attempts',
    'reconnect_interval',
    'zone',
    'nodeid',
    'sslreneg',
];

sub _init
{
    my ($self, %args) = @_;

    $self->api::Class::SSLConfig::_init(%args);
    $self->api::Class::ServerLoginInfo::_init(%args);

    $self->{_server_config_name}  = $args{server_config_name} | 'server';
    $self->{_hostname}            = $args{hostname};
    $self->{_back_channel_ip}     = $args{back_channel_ip};
    $self->{_main_channel_port}   = $args{main_channel_port} | 2224;
    $self->{_back_channel_port}   = $args{back_channel_port} | 2228;
    $self->{_util_channel_port}   = $args{util_channel_port} | 2225;
    $self->{_pek_path}            = $args{pek_path};
    $self->{_workers}             = $args{workers} | 1;
    $self->{_polling_interval}    = $args{polling_interval} | 0;
    $self->{_log_level}           = $args{log_level} | 'INFO';
    $self->{_CriticalAlertScript} = $args{CriticalAlertScript} | '';
    $self->{_reconnect_attempts}  = $args{reconnect_attempts} | '-1';
    $self->{_reconnect_interval}  = $args{reconnect_interval} | 30;
    $self->{_zone}                = $args{zone};
    $self->{_nodeid}              = $args{nodeid};
    $self->{_sslreneg}            = $args{sslreneg} | 1800;
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
