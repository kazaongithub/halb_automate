package api::Class::_Initializable;

sub new
{
    my ($class, %args) = @_;

    my $self = bless {}, ref($class)||$class;
    $self->_init(%args);
    return $self;
}

1;
