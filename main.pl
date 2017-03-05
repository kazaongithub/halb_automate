#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;
use IO::File;

use api::Class::Server;
use api::Class::Host;
use api::Class::User;
use api::GenericAPIs::Telnet;
use api::GenericAPIs::TtyUtils;
use api::GenericAPIs::RemoteUtils;
use api::GenericAPIs::CommonUtils;
use api::GenericAPIs::Cfm2Util;
use api::GenericAPIs::HelperMethods;
use api::GenericAPIs::ParseConfig;

use Config::Results;
use Config::ServerConfig;
use Config::Util;

our $server_flag = 0;

sub connect_server
{
    my $server_obj_hash = shift;

    foreach my $server (keys %$server_obj_hash) {

        my $server_obj = $server_obj_hash->{$server};

        my $user_name  = $server_obj->get_user_name();
        my $user_pswd  = $server_obj->get_user_pswd();
        my $prompt     = $server_obj->get_prompt();
        my $hostname   = $server_obj->get_hostname();
        my $plain_log  = $server_obj->get_plain_log();
        my $util_log   = $server_obj->get_util_log();
        my $server_log = $server_obj->get_server_log();

        # launch plain tty and set in server object
        $server_obj->set_plain_tty (
            &open_pty (
                user_name => $user_name,
                user_pswd => $user_pswd,
                prompt    => $prompt,
                hostname  => $hostname,
                log_file  => $plain_log,
            )
        );

        # launch util tty and set in server object
        $server_obj->set_util_tty (
            &open_pty (
                user_name => $user_name,
                user_pswd => $user_pswd,
                prompt    => $prompt,
                hostname  => $hostname,
                log_file  => $util_log,
            )
        );

        # launch server tty and set in server object
        $server_obj->set_server_tty (
            &open_pty (
                user_name => $user_name,
                user_pswd => $user_pswd,
                prompt    => $prompt,
                hostname  => $hostname,
                log_file  => $server_log,
            )
        );
    }
}

#
# Read all server's config information
# Create server objects
#
# Return hash with server name and object
#
sub create_server_objs
{
    my $server_obj_hash;

    my $AUObj = new api::Class::User (%$def_au_info);

    foreach my $server_name (keys %$all_server_info) {
        my $Obj = new api::Class::Server(
            %{$all_server_info->{$server_name}},
            %{$server_common_info},
            %{$cfm3util_info},
            plain_log        => $logs_dir . "/" . "$server_name" . "_plain.log",
            util_log         => $logs_dir . "/" . "$server_name" . "_util.log",
            server_log       => $logs_dir . "/" . "$server_name" . "_server.log",
            success_cmd_opts => $success_opt_str_hash,
            AUObj            => $AUObj,
        );

        $$server_obj_hash{$server_name} = $Obj;
    }

    return $server_obj_hash; 
}

sub main
{
    # Craete logs dir
    create_directory ($logs_dir);

    # Create host obj
    my $host_obj = new api::Class::Host(%$sdk_info);

    # Create server objects
    my $server_obj_hash = create_server_objs();

    create_directory ($config_files_dir);
    # Create server config's
    create_server_configs (
        dir         => $config_files_dir,
        server_hash => $server_obj_hash,
    );

    # Connect to all server's
    connect_server($server_obj_hash);

    # Install SDK's on all server's
    foreach my $server_name (keys %$server_obj_hash) {
        install_driver_sdk($server_obj_hash->{$server_name}, $host_obj);
        install_cav_server_sdk($server_obj_hash->{$server_name}, $host_obj);
        copy_pek_on_server($server_obj_hash->{$server_name}, $host_obj);
        copy_config_on_server($server_obj_hash->{$server_name}, $host_obj, $config_files_dir);
    }

    # setNodeId on all server's
    foreach my $server_name (keys %$server_obj_hash) {
        util_setNodeId($server_obj_hash->{$server_name});
    }

    #print Dumper $server_obj_hash;
}

main();
