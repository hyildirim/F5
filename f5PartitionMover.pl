# read the config file and create delete commands
use strict;
use warnings;
my @changes;
my $fileName = $ARGV[0];
our $newConfig = "newCustomerConfig.txt";
our $customerPartition = "Common";

# First make sure to create the new partition and save the config
push (@changes, "tmsh save sys ucs beforeMaintenance.ucs");
push (@changes, "tmsh create auth partition $customerPartition");

deleteExistingConfig($fileName, \@changes);
createNewConfig($fileName, \@changes);
#print join("\n", @changes) . "\n";
open (OUT, ">$newConfig"); print OUT join("\n", @changes) . "\n"; close OUT;
exit;


sub createNewConfig
{
   my ($f, $changes) = @_;
 
   
   
   
   open (F, "$f");
   while (<F>)
   {
      chomp;
      if (/^ltm node/)
      {
         $_ =~ s/ session monitor-enabled //g;
         $_ =~ s/ session monitor-enabled //g;
         $_ =~ s/state up//g;
         $_ =~ s/state down//g;
         my @a = split(/\s+/); shift(@a); shift(@a); my $node = shift(@a);
         push (@{$changes}, "tmsh create ltm node \/$customerPartition/$node " . join(" ", @a));
      }
   }
   close F;
   
   open (F, "$f");
   while (<F>)
   {
      chomp;
      if (/^ltm pool/)
      {
         $_ =~ s/ members \{/ members replace-all-with \{/g;
         $_ =~ s/ session monitor-enabled //g;
         $_ =~ s/state up//g;
         $_ =~ s/state down//g;
         $_ =~ s/ monitor / monitor \/Common\//g;
         my @a = split(/\s+/); shift(@a); shift(@a); my $pool = shift(@a);
         push (@{$changes}, "tmsh create ltm pool \/$customerPartition/$pool " . join(" ", @a));
      }
   }
   close F;
   
   open (F, "$f");
   while (<F>)
   {
      chomp;
      if (/^ltm virtual/)
      {
         $_ =~ s/ profiles \{/ profiles replace-all-with \{/g;
         $_ =~ s/ session monitor-enabled //g;
         $_ =~ s/state up//g;
         $_ =~ s/state down//g;
         $_ =~ s/ monitor / monitor \/Common\//g;
         my @a = split(/\s+/); shift(@a); shift(@a); my $vs = shift(@a);
         pop(@a); pop(@a); pop(@a); push(@a, "}");
         push (@{$changes}, "tmsh create ltm virtual \/$customerPartition/$vs " . join(" ", @a));
      }
   }
   close F;
   
   return;
}


sub deleteExistingConfig
{
   my ($f, $changes) = @_;
   open (F, "$f");
   while (<F>)
   {
      chomp;
      if (/^ltm virtual/)
      {
         my @a = split(/\s+/);
         my $vs = $a[2];
         push (@{$changes}, "tmsh delete ltm virtual \/Common\/$vs");
      }
      
      if (/^ltm pool/)
      {
         my @a = split(/\s+/);
         my $pool = $a[2];
         push (@{$changes}, "tmsh delete ltm pool  \/Common\/$pool");
      }
      
      if (/^ltm node/)
      {
         my @a = split(/\s+/); my $node = $a[2];
         push (@{$changes}, "tmsh delete ltm node  \/Common\/$node");
      }
   }
   close F;
   return;
}
