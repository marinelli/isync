#! /usr/bin/perl -w
#
# Copyright (C) 2006,2013 Oswald Buddenhagen <ossi@users.sf.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;
use File::Path;

-d "tmp" or mkdir "tmp";
chdir "tmp" or die "Cannot enter temp direcory.\n";

sub show($$$);
sub test($$$@);

################################################################################

# generic syncing tests
my @x01 = (
 [ 8,
   1, 1, "F", 2, 2, "", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "F", 7, 7, "FT", 9, 0, "" ],
 [ 8,
   1, 1, "", 2, 2, "F", 3, 3, "F", 4, 4, "", 5, 5, "", 7, 7, "", 8, 8, "", 10, 0, "" ],
 [ 8, 0, 0,
   1, 1, "", 2, 2, "", 3, 3, "", 4, 4, "", 5, 5, "", 6, 6, "", 7, 7, "", 8, 8, "" ],
);

my @O01 = ("", "", "");
#show("01", "01", "01");
my @X01 = (
 [ 10,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "FT", 7, 7, "FT", 9, 9, "", 10, 10, "" ],
 [ 10,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 5, "T", 7, 7, "FT", 8, 8, "T", 9, 10, "", 10, 9, "" ],
 [ 9, 0, 9,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 0, "", 7, 7, "FT", 0, 8, "", 10, 9, "", 9, 10, "" ],
);
test("full", \@x01, \@X01, @O01);

my @O02 = ("", "", "Expunge Both\n");
#show("01", "02", "02");
my @X02 = (
 [ 10,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 9, 9, "", 10, 10, "" ],
 [ 10,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 9, 10, "", 10, 9, "" ],
 [ 9, 0, 9,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 10, 9, "", 9, 10, "" ],
);
test("full + expunge both", \@x01, \@X02, @O02);

my @O03 = ("", "", "Expunge Slave\n");
#show("01", "03", "03");
my @X03 = (
 [ 10,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "FT", 7, 7, "FT", 9, 9, "", 10, 10, "" ],
 [ 10,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 9, 10, "", 10, 9, "" ],
 [ 9, 0, 9,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 0, "T", 6, 0, "", 7, 0, "T", 10, 9, "", 9, 10, "" ],
);
test("full + expunge slave", \@x01, \@X03, @O03);

my @O04 = ("", "", "Sync Pull\n");
#show("01", "04", "04");
my @X04 = (
 [ 9,
   1, 1, "F", 2, 2, "", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "F", 7, 7, "FT", 9, 9, "" ],
 [ 9,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 5, "T", 7, 7, "FT", 8, 8, "T", 9, 9, "", 10, 0, "" ],
 [ 9, 0, 0,
   1, 1, "F", 2, 2, "", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "", 7, 7, "FT", 0, 8, "", 9, 9, "" ],
);
test("pull", \@x01, \@X04, @O04);

my @O05 = ("", "", "Sync Flags\n");
#show("01", "05", "05");
my @X05 = (
 [ 8,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "F", 7, 7, "FT", 9, 0, "" ],
 [ 8,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 5, "T", 7, 7, "FT", 8, 8, "", 10, 0, "" ],
 [ 8, 0, 0,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "", 7, 7, "FT", 8, 8, "" ],
);
test("flags", \@x01, \@X05, @O05);

my @O06 = ("", "", "Sync Delete\n");
#show("01", "06", "06");
my @X06 = (
 [ 8,
   1, 1, "F", 2, 2, "", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "FT", 7, 7, "FT", 9, 0, "" ],
 [ 8,
   1, 1, "", 2, 2, "F", 3, 3, "F", 4, 4, "", 5, 5, "", 7, 7, "", 8, 8, "T", 10, 0, "" ],
 [ 8, 0, 0,
   1, 1, "", 2, 2, "", 3, 3, "", 4, 4, "", 5, 5, "", 6, 0, "", 7, 7, "", 0, 8, "" ],
);
test("deletions", \@x01, \@X06, @O06);

my @O07 = ("", "", "Sync New\n");
#show("01", "07", "07");
my @X07 = (
 [ 10,
   1, 1, "F", 2, 2, "", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "F", 7, 7, "FT", 9, 9, "", 10, 10, "" ],
 [ 10,
   1, 1, "", 2, 2, "F", 3, 3, "F", 4, 4, "", 5, 5, "", 7, 7, "", 8, 8, "", 9, 10, "", 10, 9, "" ],
 [ 9, 0, 9,
   1, 1, "", 2, 2, "", 3, 3, "", 4, 4, "", 5, 5, "", 6, 6, "", 7, 7, "", 8, 8, "", 10, 9, "", 9, 10, "" ],
);
test("new", \@x01, \@X07, @O07);

my @O08 = ("", "", "Sync PushFlags PullDelete\n");
#show("01", "08", "08");
my @X08 = (
 [ 8,
   1, 1, "F", 2, 2, "F", 3, 3, "FS", 4, 4, "", 5, 5, "T", 6, 6, "F", 7, 7, "FT", 9, 0, "" ],
 [ 8,
   1, 1, "", 2, 2, "F", 3, 3, "F", 4, 4, "", 5, 5, "", 7, 7, "", 8, 8, "T", 10, 0, "" ],
 [ 8, 0, 0,
   1, 1, "", 2, 2, "F", 3, 3, "F", 4, 4, "", 5, 5, "", 6, 6, "", 7, 7, "", 0, 8, "" ],
);
test("push flags + pull deletions", \@x01, \@X08, @O08);

# size restriction tests

my @x10 = (
 [ 0,
   1, 0, "", 2, 0, "*" ],
 [ 0,
   3, 0, "*" ],
 [ 0, 0, 0,
    ],
);

my @O11 = ("MaxSize 1k\n", "MaxSize 1k\n", "");
#show("10", "11", "11");
my @X11 = (
 [ 2,
   1, 1, "", 2, 2, "*" ],
 [ 2,
   3, 1, "*", 1, 2, "" ],
 [ 2, 0, 1,
   -1, 1, "", 1, 2, "", 2, -1, "" ],
);
test("max size", \@x10, \@X11, @O11);

test("max size verification", \@X11, \@X11, @O11);

my @O22 = ("", "MaxSize 1k\n", "");
#show("11", "22", "22");
my @X22 = (
 [ 3,
   1, 1, "", 2, 2, "*", 3, 3, "*" ],
 [ 2,
   3, 1, "*", 1, 2, "" ],
 [ 2, 0, 1,
   3, 1, "", 1, 2, "", 2, -1, "" ],
);
test("slave max size", \@X11, \@X22, @O22);

# expiration tests

my @x30 = (
 [ 0,
   1, 0, "F", 2, 0, "S", 3, 0, "S", 4, 0, "", 5, 0, "" ],
 [ 0,
   ],
 [ 0, 0, 0,
    ],
);

my @O31 = ("", "", "MaxMessages 3\n");
#show("30", "31", "31");
my @X31 = (
 [ 5,
   1, 1, "F", 2, 2, "S", 3, 3, "S", 4, 4, "", 5, 5, "" ],
 [ 5,
   1, 1, "F", 2, 2, "S", 3, 3, "S", 4, 4, "", 5, 5, "" ],
 [ 5, 0, 0,
   1, 1, "F", 2, 2, "S", 3, 3, "S", 4, 4, "", 5, 5, "" ],
);
test("max messages", \@x30, \@X31, @O31);

my @O41 = ("", "", "MaxMessages 3\nExpunge Both\n");
#show("40", "41", "41");
my @X41 = (
 [ 5,
   1, 1, "F", 2, 2, "S", 3, 3, "S", 4, 4, "", 5, 5, "" ],
 [ 5,
   1, 1, "F", 3, 3, "S", 4, 4, "", 5, 5, "" ],
 [ 5, 2, 0,
   1, 1, "F", 3, 3, "S", 4, 4, "", 5, 5, "" ],
);
test("max messages catch-up", \@X31, \@X41, @O41);

my @x50 = (
 [ 5,
   1, 1, "FS", 2, 2, "FS", 3, 3, "", 4, 4, "", 5, 5, "" ],
 [ 5,
   1, 1, "S", 2, 2, "ST", 3, 3, "", 4, 4, "", 5, 5, "" ],
 [ 5, 2, 0,
   1, 1, "FS", 2, 2, "XS", 3, 3, "", 4, 4, "", 5, 5, "" ],
);

my @O51 = ("", "", "MaxMessages 3\nExpunge Both\n");
#show("50", "51", "51");
my @X51 = (
 [ 5,
   1, 1, "S", 2, 2, "FS", 3, 3, "", 4, 4, "", 5, 5, "" ],
 [ 5,
   2, 2, "FS", 3, 3, "", 4, 4, "", 5, 5, "" ],
 [ 5, 2, 0,
   2, 2, "FS", 3, 3, "", 4, 4, "", 5, 5, "" ],
);
test("max messages + expire", \@x50, \@X51, @O51);


################################################################################

chdir "..";
rmdir "tmp";
print "OK.\n";
exit 0;


sub qm($)
{
	shift;
	s/\\/\\\\/g;
	s/\"/\\"/g;
	s/\"/\\"/g;
	s/\n/\\n/g;
	return $_;
}

# $master, $slave, $channel
sub writecfg($$$)
{
	open(FILE, ">", ".mbsyncrc") or
		die "Cannot open .mbsyncrc.\n";
	print FILE
"FSync None

MaildirStore master
Path ./
Inbox ./master
".shift()."
MaildirStore slave
Path ./
Inbox ./slave
".shift()."
Channel test
Master :master:
Slave :slave:
SyncState *
".shift();
	close FILE;
}

sub killcfg()
{
	unlink ".mbsyncrc";
}

# $options
sub runsync($)
{
#	open FILE, "valgrind -q --log-fd=3 ../mbsync ".shift()." -c .mbsyncrc test 3>&2 2>&1 |";
	open FILE, "../mbsync -D -Z ".shift()." -c .mbsyncrc test 2>&1 |";
	my @out = <FILE>;
	close FILE or push(@out, $! ? "*** error closing mbsync: $!\n" : "*** mbsync exited with signal ".($?&127).", code ".($?>>8)."\n");
	return $?, @out;
}


# $path
sub readbox($)
{
	my $bn = shift;

	(-d $bn) or
		die "No mailbox '$bn'.\n";
	(-d $bn."/tmp" and -d $bn."/new" and -d $bn."/cur") or
		die "Invalid mailbox '$bn'.\n";
	open(FILE, "<", $bn."/.uidvalidity") or die "Cannot read UID validity of mailbox '$bn'.\n";
	my $dummy = <FILE>;
	chomp(my $mu = <FILE>);
	close FILE;
	my %ms = ();
	for my $d ("cur", "new") {
		opendir(DIR, $bn."/".$d) or next;
		for my $f (grep(!/^\.\.?$/, readdir(DIR))) {
			my ($uid, $flg, $num);
			if ($f =~ /^\d+\.\d+_\d+\.[-[:alnum:]]+,U=(\d+):2,(.*)$/) {
				($uid, $flg) = ($1, $2);
			} elsif ($f =~ /^\d+\.\d+_(\d+)\.[-[:alnum:]]+:2,(.*)$/) {
				($uid, $flg) = (0, $2);
			} else {
				print STDERR "unrecognided file name '$f' in '$bn'.\n";
				exit 1;
			}
			open(FILE, "<", $bn."/".$d."/".$f) or die "Cannot read message '$f' in '$bn'.\n";
			my $sz = 0;
			while (<FILE>) {
				/^Subject: (\d+)$/ && ($num = $1);
				$sz += length($_);
			}
			close FILE;
			if (!defined($num)) {
				print STDERR "message '$f' in '$bn' has no identifier.\n";
				exit 1;
			}
			@{ $ms{$num} } = ($uid, $flg.($sz>1000?"*":""));
		}
	}
	return ($mu, %ms);
}

# $boxname
# Output:
# [ maxuid,
#   serial, uid, "flags", ... ],
sub showbox($)
{
	my ($bn) = @_;

	my ($mu, %ms) = readbox($bn);
	print " [ $mu,\n   ";
	my $frst = 1;
	for my $num (sort { $a <=> $b } keys %ms) {
		if ($frst) {
			$frst = 0;
		} else {
			print ", ";
		}
		print "$num, $ms{$num}[0], \"$ms{$num}[1]\"";
	}
	print " ],\n";
}

# $filename
# Output:
# [ maxuid[M], smaxxuid, maxuid[S],
#   uid[M], uid[S], "flags", ... ],
sub showstate($)
{
	my ($fn) = @_;

	if (!open(FILE, "<", $fn)) {
		print STDERR " Cannot read sync state $fn: $!\n";
		return;
	}
	chomp(my @ls = <FILE>);
	close FILE;
	$_ = shift(@ls);
	if (!defined $_) {
		print STDERR " Missing sync state header.\n";
		return;
	}
	if (!/^1:(\d+) 1:(\d+):(\d+)$/) {
		print STDERR " Malformed sync state header '$_'.\n";
		return;
	}
	print " [ $1, $2, $3,\n   ";
	my $frst = 1;
	for (@ls) {
		if ($frst) {
			$frst = 0;
		} else {
			print ", ";
		}
		if (!/^(-?\d+) (-?\d+) (.*)$/) {
			print "??, ??, \"??\"";
		} else {
			print "$1, $2, \"$3\"";
		}
	}
	print " ],\n";
}

# $filename
sub showchan($)
{
	my ($fn) = @_;

	showbox("master");
	showbox("slave");
	showstate($fn);
}

# $source_state_name, $target_state_name, $configs_name
sub show($$$)
{
	my ($sx, $tx, $sfxn) = @_;
	my (@sp, @sfx);
	eval "\@sp = \@x$sx";
	eval "\@sfx = \@O$sfxn";
	mkchan($sp[0], $sp[1], @{ $sp[2] });
	print "my \@x$sx = (\n";
	showchan("slave/.mbsyncstate");
	print ");\n";
	&writecfg(@sfx);
	runsync("");
	killcfg();
	print "my \@X$tx = (\n";
	showchan("slave/.mbsyncstate");
	print ");\n";
	print "test(\"\", \\\@x$sx, \\\@X$tx, \@O$sfxn);\n\n";
	rmtree "slave";
	rmtree "master";
}

# $boxname, $maxuid, @msgs
sub mkbox($$@)
{
	my ($bn, $mu, @ms) = @_;

	rmtree($bn);
	(mkdir($bn) and mkdir($bn."/tmp") and mkdir($bn."/new") and mkdir($bn."/cur")) or
		die "Cannot create mailbox $bn.\n";
	open(FILE, ">", $bn."/.uidvalidity") or die "Cannot create UID validity for mailbox $bn.\n";
	print FILE "1\n$mu\n";
	close FILE;
	while (@ms) {
		my ($num, $uid, $flg) = (shift @ms, shift @ms, shift @ms);
		if ($uid) {
			$uid = ",U=".$uid;
		} else {
			$uid = "";
		}
		my $big = $flg =~ s/\*//;
		open(FILE, ">", $bn."/".($flg =~ /S/ ? "cur" : "new")."/0.1_".$num.".local".$uid.":2,".$flg) or
			die "Cannot create message $num in mailbox $bn.\n";
		print FILE "From: foo\nTo: bar\nDate: Thu, 1 Jan 1970 00:00:00 +0000\nSubject: $num\n\n".(("A"x50)."\n")x($big*30);
		close FILE;
	}
}

# \@master, \@slave, @syncstate
sub mkchan($$@)
{
	my ($m, $s, @t) = @_;
	&mkbox("master", @{ $m });
	&mkbox("slave", @{ $s });
	open(FILE, ">", "slave/.mbsyncstate") or
		die "Cannot create sync state.\n";
	print FILE "1:".shift(@t)." 1:".shift(@t).":".shift(@t)."\n";
	while (@t) {
		print FILE shift(@t)." ".shift(@t)." ".shift(@t)."\n";
	}
	close FILE;
}

# $config, $boxname, $maxuid, @msgs
sub ckbox($$$@)
{
	my ($bn, $MU, @MS) = @_;

	my ($mu, %ms) = readbox($bn);
	if ($mu != $MU) {
		print STDERR "MAXUID mismatch for '$bn' (got $mu, wanted $MU).\n";
		return 1;
	}
	while (@MS) {
		my ($num, $uid, $flg) = (shift @MS, shift @MS, shift @MS);
		if (!defined $ms{$num}) {
			print STDERR "No message $bn:$num.\n";
			return 1;
		}
		if ($ms{$num}[0] ne $uid) {
			print STDERR "UID mismatch for $bn:$num.\n";
			return 1;
		}
		if ($ms{$num}[1] ne $flg) {
			print STDERR "Flag mismatch for $bn:$num.\n";
			return 1;
		}
		delete $ms{$num};
	}
	if (%ms) {
		print STDERR "Excess messages in '$bn': ".join(", ", sort({$a <=> $b } keys(%ms))).".\n";
		return 1;
	}
	return 0;
}

# $filename, @syncstate
sub ckstate($@)
{
	my ($fn, @T) = @_;
	open(FILE, "<", $fn) or die "Cannot read sync state $fn.\n";
	my $l = <FILE>;
	chomp(my @ls = <FILE>);
	close FILE;
	if (!defined $l) {
		print STDERR "Sync state header missing.\n";
		return 1;
	}
	chomp($l);
	my $xl = "1:".shift(@T)." 1:".shift(@T).":".shift(@T);
	if ($l ne $xl) {
		print STDERR "Sync state header mismatch: '$l' instead of '$xl'.\n";
		return 1;
	} else {
		for $l (@ls) {
			if (!@T) {
				print STDERR "Excess sync state entry: '$l'.\n";
				return 1;
			}
			$xl = shift(@T)." ".shift(@T)." ".shift(@T);
			if ($l ne $xl) {
				print STDERR "Sync state entry mismatch: '$l' instead of '$xl'.\n";
				return 1;
			}
		}
		if (@T) {
			print STDERR "Missing sync state entry: '".shift(@T)." ".shift(@T)." ".shift(@T)."'.\n";
			return 1;
		}
	}
	return 0;
}

# \@chan_state
sub ckchan($)
{
	my ($cs) = @_;
	my $rslt = ckstate("slave/.mbsyncstate.new", @{ $$cs[2] });
	$rslt |= &ckbox("master", @{ $$cs[0] });
	$rslt |= &ckbox("slave", @{ $$cs[1] });
	return $rslt;
}

sub printbox($$@)
{
	my ($bn, $mu, @ms) = @_;

	print " [ $mu,\n   ";
	my $frst = 1;
	while (@ms) {
		if ($frst) {
			$frst = 0;
		} else {
			print ", ";
		}
		print shift(@ms).", ".shift(@ms).", \"".shift(@ms)."\"";
	}
	print " ],\n";
}

# @syncstate
sub printstate(@)
{
	my (@t) = @_;

	print " [ ".shift(@t).", ".shift(@t).", ".shift(@t).",\n   ";
	my $frst = 1;
	while (@t) {
		if ($frst) {
			$frst = 0;
		} else {
			print ", ";
		}
		print shift(@t).", ".shift(@t).", \"".shift(@t)."\"";
	}
	print " ],\n";
	close FILE;
}

# \@chan_state
sub printchan($)
{
	my ($cs) = @_;

	&printbox("master", @{ $$cs[0] });
	&printbox("slave", @{ $$cs[1] });
	printstate(@{ $$cs[2] });
}

# $title, \@source_state, \@target_state, @channel_configs
sub test($$$@)
{
	my ($ttl, $sx, $tx, @sfx) = @_;

	return 0 if (scalar(@ARGV) && !grep { $_ eq $ttl } @ARGV);
	print "Testing: ".$ttl." ...\n";
	mkchan($$sx[0], $$sx[1], @{ $$sx[2] });
	&writecfg(@sfx);
	my ($xc, @ret) = runsync("-J");
	if ($xc) {
		print "Input:\n";
		printchan($sx);
		print "Options:\n";
		print " [ ".join(", ", map('"'.qm($_).'"', @sfx))." ]\n";
		print "Expected result:\n";
		printchan($tx);
		print "Debug output:\n";
		print @ret;
		exit 1;
	}
	if (ckchan($tx)) {
		print "Input:\n";
		printchan($sx);
		print "Options:\n";
		print " [ ".join(", ", map('"'.qm($_).'"', @sfx))." ]\n";
		print "Expected result:\n";
		printchan($tx);
		print "Actual result:\n";
		showchan("slave/.mbsyncstate.new");
		print "Debug output:\n";
		print @ret;
		exit 1;
	}
	open(FILE, "<", "slave/.mbsyncstate.journal") or
		die "Cannot read journal.\n";
	my @nj = <FILE>;
	close FILE;
	($xc, @ret) = runsync("-0 --no-expunge");
	killcfg();
	if ($xc) {
		print "Journal replay failed.\n";
		print "Input == Expected result:\n";
		printchan($tx);
		print "Options:\n";
		print " [ ".join(", ", map('"'.qm($_).'"', @sfx))." ], [ \"-0\", \"--no-expunge\" ]\n";
		print "Debug output:\n";
		print @ret;
		exit 1;
	}
	if (ckstate("slave/.mbsyncstate", @{ $$tx[2] })) {
		print "Journal replay failed.\n";
		print "Options:\n";
		print " [ ".join(", ", map('"'.qm($_).'"', @sfx))." ]\n";
		print "Old State:\n";
		printstate(@{ $$sx[2] });
		print "Journal:\n".join("", @nj)."\n";
		print "Expected New State:\n";
		printstate(@{ $$tx[2] });
		print "New State:\n";
		showstate("slave/.mbsyncstate");
		print "Debug output:\n";
		print @ret;
		exit 1;
	}
	rmtree "slave";
	rmtree "master";
}
