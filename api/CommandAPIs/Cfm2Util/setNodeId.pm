package api::CommandAPIs::Cfm2Util::setNodeId;

# Config
use Config::Syntax;

# Generic
use api::GenericAPIs::ProcessResult;
use api::GenericAPIs::ProcessStrings;

sub execute 
{
    my (%args) = @_;

    # Command name
    my $cmd_name = "setNodeId";
    my $testRet  = 0;
    my $testErr  = 'PARTITION_CMD_ERR_setNodeId';
    my $util     = (split /::/, __PACKAGE__)[2];

    # Get user details
    my %attrs;
    $attrs{'nodeid'} = $args{nodeid};

    # Get then command syntax
    my $cmd = $util_cmds_syntax{$cmd_name};

    # Form the command
    &substitute(\$cmd, \%attrs);

    # Execute the command on tty and check status
    my @cmd_result = $args{tty}->cmd (
        String  => $cmd,
        Prompt  => $args{prompt},
        Timeout => $args{timeout},
    );
    my $status = &checkStatus($args{status_args_hash}, \@cmd_result, 0);

    if ($status) {
        $testRet = $testErr;
    }

    return $testRet;
}

1;
