package api::GenericAPIs::Telnet;

use strict;
use warnings;
use Net::Telnet;
use Exporter;
use Carp;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
	&open_pty
	&close_pty
);

# Constant global variables
use constant SSH_TIMEOUT => 1800;

sub spwan_pty 
{
	my (@cmd) = @_;
	my ($pid, $tty, $tty_fd);

	# Create a new pseudo terminal
	use IO::Pty ();
	my $pty = new IO::Pty or die $!;

	# Execute the program in another process
	# Child process
	unless ($pid = fork) {
		die "problem spawning program: $!\n" unless defined $pid;

		# Disassociate process from existing controlling terminal
		use POSIX ();
		POSIX::setsid
			or die "setsid failed: $!";

		# Associate process with new controlling terminal
		$pty->make_slave_controlling_terminal;
		$pty->set_raw();
		$tty = $pty->slave();
		$tty_fd = $tty->fileno;
		close $pty;

		# Make stdio use the new controlling terminal
		open STDIN, "<&$tty_fd" or die $!;
		open STDOUT, ">&$tty_fd" or die $!;
		open STDERR, ">&STDOUT" or die $!;
		close $tty;

		exec @cmd
			or die "problem executing $cmd[0]\n";
	} # end child process  

	$pty;
}

sub open_pty 
{
	my (%args) = @_;

	# Start ssh program.
	my $pty = &spwan_pty("ssh",
		"-l", $args{user_name},
		"-e", "none",
		"-F", "/dev/null",
		"-o", "PreferredAuthentications=password",
		"-o", "NumberOfPasswordPrompts=1",
		"-o", "StrictHostKeyChecking=no",
		"-o", "UserKnownHostsFile=/dev/null",
		$args{hostname}
	);

	# Create a Net::Telnet object to perform I/0 on ssh's tty
	my $ssh = new Net::Telnet (
		-fhopen          => $pty,
		-prompt          => $args{prompt},
		-telnetmode      => 0,
		-cmd_remove_mode => 1,
		-timeout         => SSH_TIMEOUT,
		-output_record_separator => "\r",
        -max_buffer_length => 50*1024*1024,
		#-errmode         => sub { print "Telnet FAIL\n"; }
	);

	# Wait for the password prompt and send password.
	$ssh->waitfor(-match => '/password: ?$/i', -errmode => "return")
		or die "problem connecting to \"$args{hostname}\": ", $ssh->lastline;

	$ssh->print($args{user_pswd});

	# Wait for the shell prompt.
	my (undef, $match) = $ssh->waitfor(
		-match => $ssh->prompt,
		-match => '/^Permission denied/m',
		-errmode => "return"
	) or return $ssh->error("login failed: expected shell prompt ", "doesn't match actual\n");

	return $ssh->error("login failed: bad login-name or password\n") if $match =~ /^Permission denied/m;

	# logging 
	$ssh->input_log($args{log_file});
	$ssh->cmd("ifconfig");
	$ssh->cmd("date");
	return $ssh;
}

sub close_pty
{
	my ($tty) = shift;
	$tty->close();
}

1; 
