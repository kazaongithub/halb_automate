package api::GenericAPIs::CommonUtils;

use Exporter;
use Carp;

use api::GenericAPIs::RemoteUtils;
use api::GenericAPIs::TtyUtils;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    install_driver_sdk
    install_cav_server_sdk
    copy_pek_on_server
    copy_config_on_server
);

sub install_driver_sdk
{
    my ($server_obj, $host_obj) = @_;

    my $tty          = $server_obj->get_plain_tty();
    my $sdk_dir      = $server_obj->get_sdk_dir();
    my $sdk_path     = $server_obj->get_sdk_path();
    my $prompt       = $server_obj->get_prompt();
    my $pkgs_dir     = $server_obj->get_pkgs_dir();
    my $sdk_software = $server_obj->get_sdk_software();
    my $partition    = $server_obj->get_PARTITION();

    my $hostname        = $server_obj->get_hostname();
    my $user_name       = $server_obj->get_user_name();
    my $user_pswd       = $server_obj->get_user_pswd();

    my $host_pkgs_dir   = $host_obj->get_pkgs_dir();
    my $host_driver_sdk = $host_obj->get_driver_sdk();

    # Remove sdk directory
    remove_dir (
        tty    => $tty,
        prompt => $prompt,
        dir    => $sdk_dir,
    );

    # Create directory
    create_dir (
        tty    => $tty,
        prompt => $prompt,
        dir    => $pkgs_dir,
    );

    # Copy sdk
    remote_copy (
        hostname   => $hostname,
        user       => $user_name,
        password   => $user_pswd,
        host_dir   => $host_pkgs_dir,
        host_files => [$host_driver_sdk],
        remote_dir => $pkgs_dir,
    );

    # Set driver pkg in server
    my $server_driver_sdk_pkg = $pkgs_dir . "/" . $host_driver_sdk;
    $server_obj->set_driver_sdk($server_driver_sdk_pkg);

    # Untar driver sdk
    untar_pkg (
        tty    => $tty,
        prompt => $prompt,
        pkg    => $server_driver_sdk_pkg,
        path   => $sdk_path,
    );

    # Compile driver sdk
    execute_cmd (
        tty    => $tty,
        prompt => $prompt,
        path   => $sdk_software,
        cmd    => "make clean; make -s; make hsm_reload partition=\"$partition\"",
    );

    # Load driver sdk
    execute_cmd (
        tty    => $tty,
        prompt => $prompt,
        path   => $sdk_software,
        cmd    => "make hsm_reload partition=\"$partition\"",
    );

    # Wait for driver to load
    sleep 2;

}

sub install_cav_server_sdk
{
    my ($server_obj, $host_obj) = @_;

    my $tty          = $server_obj->get_plain_tty();
    my $server_dir   = $server_obj->get_server_dir();
    my $prompt       = $server_obj->get_prompt();
    my $pkgs_dir     = $server_obj->get_pkgs_dir();
    my $sdk_apps     = $server_obj->get_sdk_apps();
    my $server_dir   = $server_obj->get_server_dir();

    my $hostname        = $server_obj->get_hostname();
    my $user_name       = $server_obj->get_user_name();
    my $user_pswd       = $server_obj->get_user_pswd();

    my $host_pkgs_dir   = $host_obj->get_pkgs_dir();
    my $host_server_sdk = $host_obj->get_server_sdk();

    # Remove server sdk directory
    remove_dir (
        tty    => $tty,
        prompt => $prompt,
        dir    => $server_dir,
    );

    # Create directory
    create_dir (
        tty    => $tty,
        prompt => $prompt,
        dir    => $pkgs_dir,
    );

    # Copy sdk
    remote_copy (
        hostname   => $hostname,
        user       => $user_name,
        password   => $user_pswd,
        host_dir   => $host_pkgs_dir,
        host_files => [$host_server_sdk],
        remote_dir => $pkgs_dir,
    );

    # Set server pkg in server
    my $server_sdk_pkg = $pkgs_dir . "/" . $host_server_sdk;
    $server_obj->set_server_sdk($server_sdk_pkg);

    # Untar Server sdk
    untar_pkg (
        tty    => $tty,
        prompt => $prompt,
        pkg    => $server_sdk_pkg,
        path   => $sdk_apps,
    );

    # Compile Server sdk
    execute_cmd (
        tty    => $tty,
        prompt => $prompt,
        path   => $server_dir,
        cmd    => "make clean; make -s",
    );
}

sub copy_pek_on_server
{
    my ($server_obj, $host_obj) = @_;

    my $tty           = $server_obj->get_plain_tty();
    my $server_dir    = $server_obj->get_server_dir();
    my $prompt        = $server_obj->get_prompt();
    my $pek_path      = $server_obj->get_pek_path();

    my $hostname      = $server_obj->get_hostname();
    my $user_name     = $server_obj->get_user_name();
    my $user_pswd     = $server_obj->get_user_pswd();

    my $host_pkgs_dir = $host_obj->get_pkgs_dir();
    my $host_pek_file = $host_obj->get_pek_file();

    # Create directory
    create_dir (
        tty    => $tty,
        prompt => $prompt,
        dir    => $pek_path,
    );

    # Copy sdk
    remote_copy (
        hostname   => $hostname,
        user       => $user_name,
        password   => $user_pswd,
        host_dir   => $host_pkgs_dir,
        host_files => [$host_pek_file],
        remote_dir => $pek_path,
    );
}

sub copy_config_on_server
{
    my ($server_obj, $host_obj, $config_files_dir) = @_;

    my $tty           = $server_obj->get_plain_tty();
    my $server_dir    = $server_obj->get_server_dir();
    my $prompt        = $server_obj->get_prompt();
    my $server_config = $server_obj->get_server_config();
    my $sdk_path      = $server_obj->get_sdk_path();

    my $hostname      = $server_obj->get_hostname();
    my $user_name     = $server_obj->get_user_name();
    my $user_pswd     = $server_obj->get_user_pswd();

    # Create directory
    create_dir (
        tty    => $tty,
        prompt => $prompt,
        dir    => $sdk_path,
    );

    # Copy sdk
    remote_copy (
        hostname   => $hostname,
        user       => $user_name,
        password   => $user_pswd,
        host_dir   => $config_files_dir,
        host_files => [$server_config],
        remote_dir => $sdk_path,
    );

    $server_obj->set_server_config($sdk_path . "/" . $server_config);
}

1; 
