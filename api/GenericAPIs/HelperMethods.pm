package api::GenericAPIs::HelperMethods;

use Exporter;
use File::Path qw(make_path);
use Carp;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    create_directory
);

sub create_directory
{
    my ($dir) = @_;

    make_path($dir, {error => \my $err} );
    if (@$err) {
        croak ("Unable to create $dir directory\n");
    }

    return 0;
}

1;
