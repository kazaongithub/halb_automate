package Config::ServerConfig;

use Exporter;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    $sdk_info
    $server_common_info
    $all_server_info
    $source_server
    %client_common_info
    %client_info
);

# sdk's information
our $sdk_info = {
    'pkgs_dir'   => '/home/n3fips-449/HALB_CLIENT_1/packages/new/',
    'driver_sdk' => 'CNN35XX-NFBE-Linux-Driver-KVM-XEN-PF-SDK-2.0-88.tgz',
    'server_sdk' => 'CNN35XX-NFBE-Cav-Server-2.0-48.tgz',
    'pek_file'   => 'pek.key',
};

# Server common information
our $server_common_info = {
    'user_name'        => 'root',
    'user_pswd'        => 'a',
    'prompt'           => '/[\$%#>] $/',
    'sdk_path'         => '/home/HALB',
    'pkgs_dir'         => '/home/HALB/packages',
    'sdk_dir'          => '/home/HALB/cnn35xx-nfbe-kvm-xen-pf',
    'sdk_software'     => '/home/HALB/cnn35xx-nfbe-kvm-xen-pf/software',
    'sdk_apps'         => '/home/HALB/cnn35xx-nfbe-kvm-xen-pf/software/apps',
    'server_dir'       => '/home/HALB/cnn35xx-nfbe-kvm-xen-pf/software/apps/cnn35xx-nfbe-cav-server',
    'server_pek_path'  => '/etc/cavium/nfbe0/',
    'pek_path'         => '/etc/cavium/nfbe0/pek.key',
};

# Prefered server
our $source_server = 'server_9';

# Server's information
our $all_server_info = {

    'server_1' => {
        'hostname'        => '40.0.0.53',
        'back_channel_ip' => '40.0.0.53',
        'zone'            => 1,
        'nodeid'          => 1,
        'PARTITION'       => 'P1',
    },

};

1;
