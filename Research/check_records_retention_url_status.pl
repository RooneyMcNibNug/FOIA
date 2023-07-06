#!/usr/bin/perl

my $csv_file = "agency_records_retention_db.csv";
my $column_index = 3;
open(my $fh, '<', $csv_file) or die "Failed to open file '$csv_file': $!";

# Read the CSV header row
my $header = <$fh>;
chomp $header;
my @header_columns = split(',', $header);

# Process each row in the CSV file
while (my $row = <$fh>) {
    chomp $row;
    my @columns = split(',', $row);
    next if @columns < $column_index + 1;

    # Extract the URL from the specified column
    my $url = $columns[$column_index];

    # Extract the title from the 1st column
    my $title = $columns[0];

    # Use curl command to fetch the HTTP status code
    my $curl_output = `curl -s -o /dev/null -w "%{http_code}" "$url"`;

    # Print the title and HTTP status code
    print "$title: $curl_output\n";
}

close($fh) or die "Failed to close file '$csv_file': $!";
