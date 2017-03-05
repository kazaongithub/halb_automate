package api::GenericAPIs::ProcessResult;

use Exporter;
use Data::Dumper;

# Generic
use api::GenericAPIs::ProcessStrings;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    &ordered_hash_ref
    &checkStatus
);

# Retrieving from a Hash in Insertion Order
sub ordered_hash_ref
{
    tie my %hash, 'Tie::IxHash', @_;
    return \%hash;
}

# Method to check the status key values in command output
sub checkStatus
{
    # Passing in the arguments
    my ($status_hash, $cmd_result, $LOG) = @_;

    # Local varibales
    my $statRet = 0;

    # Evaluating key value pairs in $status_hash
    for my $status_attr (keys %{$status_hash}) {
        # Intial check for key in output 
        if (searchStr ($cmd_result, $status_attr)) {

            # If respective value defined in hash
            if (${$status_hash}{$status_attr}) {
                my $status_value = processSpecialChar (${$status_hash}{$status_attr});

                if (! (matchKeyValue ($cmd_result, $status_attr, $status_value, "\\s*:\\s*"))) {
                    $statRet = 1;
                    # Printing if debug flag defined
                    #print_command_checkcase (fd => $LOG, case => "Check Status", key => $status_attr, value => $status_value, result => "FAIL", comments => "Unable to find corresponding value") if $LOG;
                } else {
                    # Printing if debug flag defined
                    #print_command_checkcase (fd => $LOG, case => "Check Status", key => $status_attr, value => $status_value, result => "PASS", comments => "") if $LOG;
                }
            } else {
                if (searchStr ($cmd_result, $status_attr)) {
                    # Printing if debug flag defined
                    #print_command_checkcase (fd => $LOG, case => "Check Status", key => $status_attr, value => "--", result => "PASS", comments => "") if $LOG;
                } else {
                    $statRet = 1;
                    # Printing if debug flag defined
                    #print_command_checkcase (fd => $LOG, case => "Check Status", key => $status_attr, value => "--", result => "FAIL", comments => "Unable to find string") if $LOG;
                }
            }
        } else {
            $statRet = 1;
            # Printing if debug flag defined
            #print_command_checkcase (fd => $LOG, case => "Check Status", key => $status_attr, value => "NONE", result => "FAIL", comments => "Couldn't find status key in the output") if $LOG;
        }
    }

    return $statRet;
} # End of checkStatus

1;
