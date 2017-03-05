package Config::Syntax;

use Exporter;
our @ISA    = qw (Exporter);
our @EXPORT = qw (
    %util_cmds_syntax
);

# Cfm2Util commands syntax
our %util_cmds_syntax = (
    loginStatus => 'loginStatus',
    logoutHSM   => 'logoutHSM',
    loginHSM    => 'loginHSM -u $(user_type) -s $(user_name) -p $(password) -pek_path $(pek_path)',
    setNodeId   => 'setNodeId -n $(nodeid)',
); 

1;
