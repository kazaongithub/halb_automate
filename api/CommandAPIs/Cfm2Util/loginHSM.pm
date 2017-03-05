package api::CommandAPIs::Cfm2Util::loginHSM;

# Config
use Config::Syntax;

# Adapter
use api::Class::User;

# Generic
use api::GenericAPIs::ProcessResult;
use api::GenericAPIs::ProcessStrings;

sub execute 
{
    my (%args) = @_;

    # Command name
    my $cmd_name = "loginHSM";
    my $testRet  = 0;
    my $testErr  = 'PARTITION_CMD_ERR_loginHSM';
    my $util     = (split /::/, __PACKAGE__)[2];

    # Get user details
    my $userObj = $args{userObj};
    my %attrs;
    $attrs{'user_name'} = $userObj->get_user_name();
    $attrs{'password'}  = $userObj->get_password();
    $attrs{'user_type'} = $userObj->get_user_type();

    # pek path
    $attrs{'pek_path'}  = $args{pek_path};

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
