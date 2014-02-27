use strict;
use Data::Dumper;

my $d = read_seqware_settings();
my $r = {};

# error levels: critical = 1, warning = 2
print Dumper($d);

# check dirs
check_dirs();

# check the web services
check_webservice($d->{'SW_REST_URL'}, $d->{'SW_REST_USER'}, $d->{'SW_REST_PASS'});
check_webservice($d->{'SW_ADMIN_REST_URL'}, $d->{'SW_REST_USER'}, $d->{'SW_REST_PASS'});

# check direct db if not using the web service

# check mapreduce is running

# check hdfs is running
# hdfs space
# does this user have a working dir

# check oozie is running

# check SGE is running
# daemon
# listens to port
# oozie sge installed
# qaccnt
# qstat
# qsub, can you do a echo hostname | qsub and have that work?

# hbase
# online?
# reachable?

# disk space

# memory?

# hostname 

# java and version
# in path

# seqware script? Is it in path?

# network
# reach 8.8.8.8?
# reach apt-get repos?
# maven repos?



# dump results
print Dumper($r);


# sub

sub check_webservice {
  my ($url, $u, $p) = @_;
  my $result = `wget $url 2>&1`;
  print "$result\n";
  if ($result =~ /Connection refused/) {
    $r->{"Can't connect to web service at URL: $url"} = 1;
  } elsif ($result =~ /connected/) {
    $result = `wget --user=$u --password=$p $url 2&>1`;
    print "WGET: wget --user=$u --password=$p $url 2&>1";
    print "$result\n";
    if (0) {

  # LEFT OFF HERE  
    }    
  }
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
