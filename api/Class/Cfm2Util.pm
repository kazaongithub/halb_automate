package api::Class::Cfm2Util;

use vars qw ($AUTOLOAD);
use Carp;

use api::Class::_Initializable;
@api::Class::Cfm2Util::ISA = qw (api::Class::_Initializable);

sub _init
{
    my ($self, %args) = @_;
    
    # General information
    $self->{_bindist_dir}      = $args{bindist_dir};
    $self->{_util_name}        = $args{util_name};
    $self->{_util_prompt}      = $args{util_prompt};
    $self->{_util_timeout}     = $args{util_timeout};

    # Attirbute to store success command opt strings
    $self->{_success_cmd_opts} = $args{success_cmd_opts};

    # Util status flag
    $self->{_util_tty_flag}    = 0;

    # Log information
    $self->{_logObj}           = $args{logObj};
    $self->{_AUObj}            = $args{AUObj};
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
