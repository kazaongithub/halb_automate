package Config::ServerConfig;

use strict;
use warnings;
use Exporter;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    %host_common_info
    %server_common_info
    %server_info
    %client_common_info
    %client_info
);

# Common host information
our %host_common_info = (
        user_name   => 'root',
        user_pswd   => 'a',
        prompt      => '/[\$%#>] $/',
);

# Server common information
our %server_common_info = (
        sdk_path    => '/home/kaza/n3fips_2.0_release/cnn35xx-nfbe-kvm-xen-pf/software/apps/cnn35xx-nfbe-cav-server/bin',
);

# Server's information
our %server_info = (
    'Server_1' => {
        hsm_name    => 'HSM1',
        ip_addr     => '192.168.190.231',
        log_file    => 'server_1.log',
        conf_file   => 'cav_server.conf',
    },

    #'Server_2' => {
    #    hsm_name    => 'HSM2',
    #    ip_addr     => '10.91.207.189',
    #    log_file    => 'server_2.log',
    #},
);

# Client common information
our %client_common_info = (
        sdk_path    => '/home/kaza/cnn35xx-nfbe-cav-client/cav-client/bindist',
);

# Client information
our %client_info = (
    'Client_1' => {
        hsm_name    => 'HSM1',
        ip_addr     => '10.91.207.189',
        log_file    => 'cleint_1.log',
        conf_file   => 'cav_cli_daemon.cfg',
    },

    #'Server_2' => {
    #    hsm_name    => 'HSM2',
    #    ip_addr     => '10.91.207.189',
    #    log_file    => 'server_2.log',
    #},
);


