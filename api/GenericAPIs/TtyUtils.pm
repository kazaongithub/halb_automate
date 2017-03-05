package api::GenericAPIs::TtyUtils;

use Exporter;
use Carp;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
	remove_dir
	create_dir
    untar_pkg
    execute_cmd
);

sub remove_dir
{
	my (%args) = @_;

	my $tty    = $args{tty};
	my $dir    = $args{dir};
	my $prompt = $args{prompt};

	$tty->cmd (String => "rm -rf $dir", Prompt => $prompt);
}

sub create_dir
{
	my (%args) = @_;

	my $tty    = $args{tty};
	my $dir    = $args{dir};
	my $prompt = $args{prompt};

	$tty->cmd (String => "mkdir -p $dir", Prompt => $prompt);
}

sub untar_pkg
{
	my (%args) = @_;

	my $tty    = $args{tty};
	my $prompt = $args{prompt};
	my $pkg    = $args{pkg};
	my $path   = $args{path};

    create_dir (%args, dir => $path);
	$tty->cmd (String => "tar -zxf $pkg -C $path", Prompt => $prompt);
}

sub execute_cmd
{
	my (%args) = @_;

	my $tty    = $args{tty};
	my $prompt = $args{prompt};
	my $path   = $args{path};
    my $cmd    = $args{cmd};

	$tty->cmd (String => "cd $path; $cmd", Prompt => $prompt);
}

1; 
