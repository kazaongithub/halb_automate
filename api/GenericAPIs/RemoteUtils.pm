package api::GenericAPIs::RemoteUtils;

use Exporter;
use Carp;
use Net::SCP::Expect;
use Data::Dumper;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    remote_copy
);

sub remote_copy
{
	my (%args) = @_;
print Dumper \%args;
	my $host       = $args{hostname};
	my $user       = $args{user};
	my $password   = $args{password};
    my $host_dir   = $args{host_dir},
    my $host_files = $args{host_files};
    my $remote_dir = $args{remote_dir};

    my $scpe = Net::SCP::Expect->new (
        host     => $host,
        user     => $user,
        password => $password,
        auto_yes => 1,
    );

    foreach $file (@$host_files) {
        $scpe->scp ("$host_dir/$file", $remote_dir);
    }
}

1; 
