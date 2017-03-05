package api::GenericAPIs::ProcessStrings;

use Exporter;
use Data::Dumper;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    &processSpecialChar
    &substitute
    &searchStr
    &matchKeyValue
);

sub processSpecialChar
{
    # Passing in the parameter
    my ($str) = @_;

    # Local variables
    my ($retStr);

    my @str_chars = split ("", $str);
    # Check for each special char in the str
    for my $ind (0..length($str)-1) {
        if (grep $_ eq $str_chars[$ind], @special_char_range) {
            $retStr .= "\\" . $str_chars[$ind];
        } else {
            $retStr .= $str_chars[$ind]
        }
    }

    # Return string
    return $retStr;
}

sub processSpecialCharForCmds
{
    # Passing in the parameter
    my ($str) = @_;

    # Local variables
    my ($offset, @char_arr);

    # Initializing the local varibales
    $offset = 0;
    @char_arr = ('[', ']', '$', '(', ')');

    # Check for each special char in the str
    for my $char (@char_arr) {
        # Get the index
        my $result = index($str, $char);

        # Loop until the end of the string is reached
        while ($result != -1) {
            # Adding '\' char
            substr ($str, $result, 0) = "\\";

            $offset = $result + 2;
            $result = index($str, $char, $offset);
        }
    }
    # Return string
    return $str;
}
 
# Substitute
sub substitute
{   
    # Passing in the arguments
    my ($cmd, $attr_hash) = @_;

    if ($$cmd =~ /\$\([\w+\s?]{1,}\)/) {
        # Get all matchs 
        my (@str_matchs) = $$cmd =~ m/\w*(-?\w*\s?\$\([\w+\s?]{1,}\))/g;

        for my $sub_str (@str_matchs) {
            # Get the substitute string
            $sub_str =~ m/(-\w*\s)?\$\(((\w+\s?){1,})\)/;

            my $target_option = defined $1 ? $1 : "";
            my $target_str    = $2;
            my $process_str   = processSpecialCharForCmds($sub_str);

            my $flag = 0;    
            if (grep {$_ eq $target_str && defined $$attr_hash{$target_str}} keys %$attr_hash) {
                $$cmd =~ s/$process_str/ $target_option$$attr_hash{$target_str}/;
                $flag = 1;
            }
            unless ($flag) {
                $$cmd =~ s/$process_str//;
            }
        }
    }
}

# Funtion to search string in an array of strings
sub searchStr
{
    # Get the values passed in
    my ($target_str_arr, $str) = @_;

    # Local variables
    my (@found_str);

    # Searching str in target string 
    # Stored into an array as it may occur multiple times.
    @found_str = grep { $_ =~ $str } @$target_str_arr;

    # If string not found, array size is zero
    # undef is returned 
    if (! scalar (@found_str)) {
        # Printing if debug flag defined
        return 0;
    } else {
        # Printing if debug flag defined
        return scalar @found_str;
    }
}
 
# Function to match key, value sepearated by a delimitor
sub matchKeyValue
{
    # Passing in arguments
    my ($str_arr_addr, $key, $value, $delimiter) = @_;

    # Local variable
    my ($match);

    # Initializing $match to 0
    $match = 0;

    # Checking key value with delimiter in each line
    for my $str (@$str_arr_addr) {
        if ($str =~ m/$key$delimiter$value/i) {
            $match = 1;
        }
    }
    # Return match
    return $match;
}
 
1;
