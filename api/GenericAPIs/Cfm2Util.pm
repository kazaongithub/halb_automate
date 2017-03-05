package api::GenericAPIs::Cfm2Util;
 
use Exporter;
use Carp;
use Data::Dumper;

use api::CommandAPIs::Cfm2Util::loginHSM;
use api::CommandAPIs::Cfm2Util::setNodeId;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    util_setNodeId
);

# setNodeId
sub util_setNodeId
{
    my ($serverObj) = shift;

    my $testRet = 0;
    my $caseRet = 0;
    my $testErr = 'PARTITION_CMD_ERR_setNodeID';

    my $tty_flag = $serverObj->get_util_tty_flag();

    unless ($tty_flag) {
        if ($caseRet = &launch_Cfm2Util($serverObj)) { $testRet = $caseRet }
    }

    my $tty          = $serverObj->get_util_tty();
    my $util_prompt  = $serverObj->get_util_prompt();
    my $util_timeout = $serverObj->get_util_timeout();
    my $output_hash  = $serverObj->get_success_cmd_opts();
    my $AUObj        = $serverObj->get_AUObj();
    my $pek_path     = $serverObj->get_pek_path();
    my $nodeid       = $serverObj->get_nodeid();

    # login as AU user
    if ($caseRet = api::CommandAPIs::Cfm2Util::loginHSM::execute(
        tty              => $tty,
        prompt           => $util_prompt,
        timeout          => $util_timeout,
        status_args_hash => $output_hash,
        userObj          => $AUObj,
        pek_path         => $pek_path,
    )) { $testRet = $caseRet }

    # setNodeId
    if ($caseRet = api::CommandAPIs::Cfm2Util::setNodeId::execute(
        tty              => $tty,
        prompt           => $util_prompt,
        timeout          => $util_timeout,
        status_args_hash => $output_hash,
        nodeid           => $nodeid,
    )) { $testRet = $caseRet }

    if ($caseRet = &close_Cfm2Util($serverObj)) { $testRet = $caseRet }

    return $testRet;
}

# Launch Cfm2Util
sub launch_Cfm2Util
{
    my ($serverObj) = shift;

    my $testRet = 0;
    my $caseRet = 0;

    my $tty = $serverObj->get_util_tty();

    my $tty_flag = $serverObj->get_util_tty_flag();
    unless ($tty_flag) {
        # get host object from part object
        my $sdk_path       = $serverObj->get_sdk_software();
        my $host_prompt    = $serverObj->get_prompt();

        my $bindist_dir    = $serverObj->get_bindist_dir();
        my $util_name      = $serverObj->get_util_name();
        my $util_prompt    = $serverObj->get_util_prompt();
        my $util_timeout   = $serverObj->get_util_timeout();
        my $partition_name = $serverObj->get_PARTITION();

        $tty->cmd (String => "cd $sdk_path", Prompt => $host_prompt);
        $tty->cmd (String => "./$bindist_dir/$util_name -p $partition_name", Prompt => $util_prompt);

        # Set master util flag
        $serverObj->set_util_tty_flag(1);
    }
    
    return $testRet;
}

# Close Cfm2Util
sub close_Cfm2Util
{
    my ($serverObj) = shift;

    my $testRet = 0;
    my $tty_flag = $serverObj->get_util_tty_flag();
    
    if ($tty_flag) {
        # get host object from part object
        my $host_prompt = $serverObj->get_prompt();
        my $tty         = $serverObj->get_util_tty();

        $tty->cmd (String => "exit", Prompt => $host_prompt);
    
        # Set master util flag
        $serverObj->set_util_tty_flag(0);
    }

    return $testRet;
}

1;
