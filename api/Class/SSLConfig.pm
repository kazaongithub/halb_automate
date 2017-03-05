package api::Class::SSLConfig;

use vars qw ($AUTOLOAD);
use Carp;

use api::Class::_Initializable;

@api::Class::SSLConfig::ISA = qw (api::Class::_Initializable);

our $attrs = [
    'certificate',
    'pkey',
    'CApath',
    'main_channel_ssl',
    'back_channel_ssl',
    'util_channel_ssl',
    'main_channel_ssl_ciphers',
    'back_channel_ssl_ciphers',
    'util_channel_ssl_ciphers',
];

sub _init
{
    my ($self, %args) = @_;

    $self->{_ssl_config_name}          = $args{ssl_config_name} | 'ssl';
    $self->{_certificate}              = $args{certificate} | '/etc/cavium/cert.pem';
    $self->{_pkey}                     = $args{pkey} | '/etc/cavium/key.pem';
    $self->{_CApath}                   = $args{CApath} | '/etc/ssl/certs';
    $self->{_main_channel_ssl}         = $args{main_channel_ssl} | 'yes';
    $self->{_back_channel_ssl}         = $args{back_channel_ssl} | 'yes';
    $self->{_util_channel_ssl}         = $args{util_channel_ssl} | 'yes';
    $self->{_main_channel_ssl_ciphers} = $args{main_channel_ssl_ciphers} | 'default';
    $self->{_back_channel_ssl_ciphers} = $args{back_channel_ssl_ciphers} | 'default';
    $self->{_util_channel_ssl_ciphers} = $args{util_channel_ssl_ciphers} | 'default';
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
