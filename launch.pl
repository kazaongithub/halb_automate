#!/usr/bin/perl 

use strict;
use warnings;
use Config::ServerConfig;
use api::GenericAPIs::Telnet;
use Data::Dumper;
use IO::File;

our $server_flag = 0;

sub main()
{
    my ($server_pid, @server_childs);

    # Server
    foreach my $server (keys %server_info) {
        $server_pid = fork();

        # Parent
        if ($server_pid != 0) {
            push (@server_childs, $server_pid);
        } elsif ($server_pid == 0) {

            my $tty = &open_pty (%host_common_info, %{$server_info{$server}});
            $tty->cmd (String => "cd $server_common_info{sdk_path}", Prompt => $host_common_info{prompt}, Timeout => 10);
            $tty->cmd (String => " ./cav_server ${$server_info{$server}}{conf_file}");

        } else {
            die "Couldn't fork: $!\n\n";
        }
    }

    my ($client_pid, @client_childs);

    ## Client 
    foreach my $client (keys %client_info) {
        $client_pid = fork();

        # Parent
        if ($client_pid != 0) {
            push (@client_childs, $client_pid);
        } elsif ($client_pid == 0) {
            my $tty = &open_pty (%host_common_info, %{$client_info{$client}});

            $tty->cmd (String => "cd $client_common_info{sdk_path}", Prompt => $host_common_info{prompt}, Timeout => 10);
            $tty->cmd (String => " ./cav_client ${$client_info{$client}}{conf_file}");
        } else {
            die "Couldn't fork: $!\n\n";
        }
    }

    1 while (wait() != -1);

}

sub search_str
{
    my ($file, $find) = @_;

    my $found_flag = 0;

    IO::File->input_record_separator($find);

    my $fh = IO::File->new($file, O_RDONLY)
      or die 'Could not open file ', $file, ": $!";

    $fh->getline;  #fast forward to the first match

    while ($fh->getline) {
        $found_flag = 1 if (IO::File->input_record_separator);
    }

    $fh->close;

    return $found_flag;
}

main();
