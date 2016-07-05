# Created by Luke Yildirim [luke.yildirim@rackspace.com]
# This script allows you apply mass changes using TMSH commands and captures the errors and 
# saves in a file for easy reading and reports them.
# When applying mass changes, it's hard to scroll up and down to find errors


$| = 1;
my @errors;
# make sure stdout and stderr files are deleted
unlink "/shared/tmp/stdout.txt";
unlink "/shared/tmp/stderror.txt";


open (C, "newCustomerConfig.txt");
while (<C>)
{
        chomp;  $c = $_;
        system($c . " 1>>/shared/tmp/stdout.txt 2>>/shared/tmp/stderror.txt");
        if ($? != 0 )
        {
                #printf "Command %s exited with value %d\n", $c, $?;
                push(@errors, $c);
        }
}


print "-" x 80 . "\n";
print " SUMMARY\n";
print "-" x 80 . "\n";

if ( scalar(@errors) > 0 )
{
        my $c = 1;
        print "Following commands failed\n";
        foreach (@errors)
        {
                print "ERROR: Command [$_] failed.\n";
                $c++;

        }

        print "-" x 80 . "\n";
        print "Here is the output for each command\n";
        open (F, "/shared/tmp/stderror.txt");
        print "-" x 80 . "\n";
        while(<F>) { print $_; }
        close F;
        print "-" x 80 . "\n";


}
else
{
        print "SUCCESS: All changes were successful\n";
}
