package Config::Results;

use Exporter;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    $logs_dir
    $config_files_dir
);

our $logs_dir         = "logs";
our $config_files_dir = "config_files";

1;
