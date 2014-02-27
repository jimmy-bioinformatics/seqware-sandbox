use strict;
use Data::Dumper;

my $d = read_seqware_settings();
my $r = {};

# error levels: critical = 1, warning = 2
print Dumper($d);

# check dirs
check_dirs();

# check the web services
check_webservice($d->{'SW_REST_URL'});
check_webservice($d->{'SW_ADMIN_REST_URL'});

# dump results
print Dumper($r);


# sub

sub check_webservice {
  my ($url) = @_;
  
}

sub check_dirs {
  if (!exists_and_writable($d->{'SW_BUNDLE_DIR'})) { $r->{"Missing your SW_BUNDLE_DIR! ".$d->{'SW_BUNDLE_DIR'}} = 1; }
  if (!exists_and_writable($d->{'SW_BUNDLE_REPO_DIR'})) { $r->{"Missing your SW_BUNDLE_REPO_DIR! ".$d->{'SW_BUNDLE_REPO_DIR'}} = 1; }
  if (!exists_and_writable($d->{'OOZIE_WORK_DIR'})) { $r->{"Missing your OOZIE_WORK_DIR! ".$d->{'OOZIE_WORK_DIR'}} = 1; }
}

sub exists_and_writable {
  my ($file_path) = @_;
  if ($file_path !~ /^http/ && $file_path !~ /^s3/ && (!-e $file_path || !-w $file_path)) { return 0; } 
  return(1);
}

sub read_seqware_settings {
  my $d = {};
  # FIXME: need to use the env variable
  if (-e $ENV{"SEQWARE_SETTINGS"}) {
    open IN, $ENV{"SEQWARE_SETTINGS"} or die "Can't open ".$ENV{"SEQWARE_SETTINGS"}."\n";
  } else {
    open IN, $ENV{"HOME"}."/.seqware/settings" or die "Can't open ".$ENV{"HOME"}."/.seqware/settings";
  }
  while(<IN>) {
    chomp;
    next if (/^\s*#/);
    if ($_ =~ /^\s*(\S+)\s*=\s*(.+)$/) {
     #print "KEY: $1 VALUE: $2\n"; 
     $d->{$1} = $2;
    }
  }
  close IN;
  return($d);
}
