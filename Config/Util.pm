package Config::Util;

use Exporter;
our @ISA    = qw (Exporter);
our @EXPORT = qw (
    $cfm3util_info
    $success_opt_str_hash
    $def_au_info
);

our $cfm3util_info = {
    'bindist_dir'  => 'bindist',
    'util_name'    => 'Cfm2Util',
    'util_prompt'  => '/(\s)*Command: (\s)*/i',
    'util_timeout' => 1500,
};

# Success command output strings
our $success_opt_str_hash = {
    'HSM Return' => 'SUCCESS',
};

our $def_au_info = {
    user_name => "app_user",
    password  => "user123",
    user_type => "AU",
};

1;
