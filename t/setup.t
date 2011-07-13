#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 7;

use lib 'lib';

use t::Utils;
rebuild_tfiles();

use Config;
my $perl = $Config{perlpath};

local $ENV{HOME} = 'tfiles';

xsystem("$perl ./bin/ubic-admin setup --batch-mode --no-install-services --local");

ok(-d 'tfiles/ubic/data', 'ubic data dir created');
ok(-d 'tfiles/ubic/log', 'ubic log dir created');
ok(-d 'tfiles/ubic/service', 'ubic service dir created');
ok(-e 'tfiles/.ubic.cfg', 'ubic config created');

my @config = split /\n/, slurp 'tfiles/.ubic.cfg';
like($config[0], qr{^default_user = \S+$}, 'default user config line');
like($config[1], qr{^service_dir = .*tfiles/ubic/service$}, 'services dir config line');
like($config[2], qr{^data_dir = .*tfiles/ubic/data$}, 'services dir config line');
