#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use LWP::Protocol::https;
use JSON;
use File::Path qw(make_path);
use URI::Escape;

# Create the FOIA_backups dir
my $backup_dir = 'FOIA_backups';
make_path($backup_dir) unless -d $backup_dir;

# cd FOIA_backups
chdir $backup_dir or die "Cannot change to directory '$backup_dir': $!";

# Config for MuckRock API
my $api_url = 'https://www.muckrock.com/api_v1/';
my $username = 'joliet_j';  # Replace with the desired username
my $token = 'your_muckrock_api_key';  # Replace with your actual API key

# Create user agent
my $ua = LWP::UserAgent->new;
$ua->default_header('Authorization' => "Bearer $token");

# Fetch FOIA requests
sub fetch_requests {
    my $url = "${api_url}foia/?user=$username";
    my @requests;

    while ($url) {
        my $response = $ua->get($url);
        if ($response->is_success) {
            my $data = decode_json($response->decoded_content);
            push @requests, @{$data->{results}};
            $url = $data->{next};  # Get the next page URL
        } else {
            die "Error fetching requests: " . $response->status_line;
        }
    }
    return @requests;
}

# Download files
sub download_files {
    my ($request) = @_;
    my $request_id = $request->{id};
    my $agency_id = $request->{agency};
    my $tracking_id = $request->{tracking_id};

    # Fetch agency name
    my $agency_response = $ua->get("${api_url}agency/$agency_id");
    my $agency_data = decode_json($agency_response->decoded_content);
    my $agency_name = $agency_data->{name};

    # Create dir for the request using the exact request name
    my $dir_name = "${agency_name}_${tracking_id}";
    $dir_name =~ s/[;:]/_/g;  # Sanitize directory name
    make_path($dir_name) unless -d $dir_name;

    # Download comms
    my $communications = $request->{communications};
    if (!$communications) {
        print "No communications for request #$request_id.\n";
        return;
    }

    # Sort communications by date
    my @sorted_communications = sort {
        $a->{date} cmp $b->{date}
    } @$communications;

    my $communication_counter = 1;  # Counter for communication files

    foreach my $communication (@sorted_communications) {
        foreach my $file (@{$communication->{files}}) {
            my $file_url = $file->{ffile};
            my $file_name = uri_unescape($file_url);
            $file_name =~ s/.*\///;  # Get the filename from the URL
            my $sanitized_file_name = $file_name;  # Use the exact file name without date
            $sanitized_file_name =~ s/[;:]/_/g;  # Sanitize filename

            # Download the file
            my $file_response = $ua->get($file_url, ':content_file' => "$dir_name/$sanitized_file_name");
            if ($file_response->is_success) {
                print "Downloaded: $sanitized_file_name\n";
            } else {
                warn "Failed to download $file_url: " . $file_response->status_line;
            }
        }

        # Save comms text (.txt files) with a unique name
        my $communication_text = $communication->{communication};
        my $text_file_name = "$dir_name/Communication_$communication_counter.txt";  # Unique name for each communication
        open my $fh, '>:encoding(UTF-8)', $text_file_name or die "Could not open file '$text_file_name': $!";
        print $fh $communication_text;
        close $fh;
        print "Saved communication text to: $text_file_name\n";

        $communication_counter++;  # Increment the counter for the next communication
    }
}

# Main
my @requests = fetch_requests();
foreach my $request (@requests) {
    print "Processing request ID: $request->{id}\n";
    download_files($request);
}
