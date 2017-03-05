package api::GenericAPIs::ParseConfig;

use api::Class::ServerConfig;
use api::Class::SSLConfig;
use api::Class::ServerLoginInfo;

use Exporter;
use Data::Dumper;

our @ISA    = qw (Exporter);
our @EXPORT = qw (
    create_server_configs
);

sub create_server_configs
{
    my (%args) = @_;

    my $dir = $args{dir};
    my $server_obj_hash = $args{server_hash};

    foreach my $server (keys %{$server_obj_hash}) {
        my $server_obj = $server_obj_hash->{$server};

        # Get config's names
        my $ssl_config_name        = $server_obj->get_ssl_config_name();
        my $server_config_name     = $server_obj->get_server_config_name();
        my $login_info_config_name = $server_obj->get_login_info_config_name();

        my $server_config_name = "$server.config";
        $server_obj->set_server_config($server_config_name);

        open(my $fh, '>', "$dir/$server.config");

        # Start
        # Open brace
        print $fh "{\n\n";
   
        # Copy ssl config params
        print $fh "\t\"$ssl_config_name\": {\n";
        foreach my $attr (@$api::Class::SSLConfig::attrs) {
            my $method_name = "get_" . $attr;
            my $attr_value = $server_obj->$method_name();

            $attr_value = "\"" . $attr_value . "\"" unless ($attr_value =~ /^-?\d+?$/);
            print $fh "\t\t\"$attr\": $attr_value,\n";
        }

        # Close ssl config params
        print $fh "\t},\n\n";

        # Copy Server config params
        print $fh "\t\"$server_config_name\": {\n";
        foreach my $attr (@$api::Class::ServerConfig::attrs) {
            my $method_name = "get_" . $attr;
            my $attr_value = $server_obj->$method_name();

            $attr_value = "\"" . $attr_value . "\"" unless ($attr_value =~ /^-?\d+?$/);
            print $fh "\t\t\"$attr\": $attr_value,\n";
        }

        # Copy Server login info params
        print $fh "\t\t\"$login_info_config_name\": {\n";
        foreach my $attr (@$api::Class::ServerLoginInfo::attrs) {
            my $method_name = "get_" . $attr;
            my $attr_value = $server_obj->$method_name();

            $attr_value = "\"" . $attr_value . "\"" unless ($attr_value =~ /^-?\d+?$/);
            print $fh "\t\t\t\"$attr\": $attr_value,\n";
        }

        # Close Server Login info params
        print $fh "\t\t},\n";

        # Close Server params
        print $fh "\t},\n\n";

        # Copy remaining Server config params
        print $fh "\t\"servers\": {\n";
        print $fh "\t\t\"version\": 1,\n";
        print $fh "\t\t\"zones\":\n";
        print $fh "\t\t\t[\n";
        print $fh "\t\t\t{\n";

        my %zoneid_hash;
        foreach my $remianing_server (keys %{$servers_obj_hash}) {
            unless ($remianing_server eq $server) {

                my $remianing_server_obj = $servers_obj_hash->{$remianing_server};
                my $remianing_server_zoneid = $remianing_server_obj->get_zone();

                push @{$zoneid_hash{$remianing_server_zoneid}}, $remianing_server_obj;
            }
        }

        my @other_servers_attr = (
            'hostname',
            'back_channel_ip',
            'main_channel_port',
            'back_channel_port',
            'nodeid',
        );

        foreach my $zone (keys %zoneid_hash) {
            
            print $fh "\t\t\t\t\"Zoneid\": $zone,\n";
            print $fh "\t\t\t\t\"server_list\":\n";
            print $fh "\t\t\t\t\t[\n";

            if (defined $zoneid_hash{$zone}) {
                my $zoneid_flag = 0;
                my $zoneid_server_size = $#{$zoneid_hash{$zone}};

                foreach my $other_server_obj (@{$zoneid_hash{$zone}}) {

                    # Open
                    print $fh "\t\t\t\t\t{\n";

                    foreach $other_attr (@other_servers_attr) {
                        my $method_name = "get_" . $other_attr;
                        my $other_attr_value = $other_server_obj->$method_name();

                        $other_attr_value = "\"" . $other_attr_value . "\"" unless ($other_attr_value =~ /^-?\d+?$/);
                        print $fh "\t\t\t\t\t\t\"$other_attr\": $other_attr_value,\n";

                    }

                    print $fh "\t\t\t\t\t\t\"enabled\": \"yes\"\n";

                    # Close
                    if ($zoneid_flag == $zoneid_server_size) {
                        print $fh "\t\t\t\t\t}\n";
                    } else {
                        print $fh "\t\t\t\t\t},\n";
                    }
                    ++$zoneid_flag;
                }
            }

            print $fh "\t\t\t\t\t]\n";
        }

        # zones close
        print $fh "\t\t\t}\n";
        print $fh "\t\t\t]\n";
        # Remaining Server's close
        print $fh "\t}\n";

        # Close config params
        print $fh "}";
        close $fh;
    }
}

1;
