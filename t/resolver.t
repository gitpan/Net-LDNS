use Test::More;

use Net::LDNS;

my $r = Net::LDNS->new( '8.8.8.8' );

$r->recurse( 0 );
ok( !$r->recurse, 'recursive off' );
$r->recurse( 1 );
ok( $r->recurse, 'recursive on' );

$r->retrans( 17 );
is( $r->retrans, 17, 'retrans set' );

$r->retry( 17 );
is( $r->retry, 17, 'retry set' );

$r->debug( 1 );
ok( $r->debug, 'debug set' );
$r->debug( 0 );
ok( !$r->debug, 'debug unset' );

$r->dnssec( 1 );
ok( $r->dnssec, 'dnssec set' );
$r->dnssec( 0 );
ok( !$r->dnssec, 'dnssec unset' );

$r->usevc( 1 );
ok( $r->usevc, 'usevc set' );
$r->usevc( 0 );
ok( !$r->usevc, 'usevc unset' );

$r->igntc( 1 );
ok( $r->igntc, 'igntc set' );
$r->igntc( 0 );
ok( !$r->igntc, 'igntc unset' );

$r->edns_size( 4711 );
is($r->edns_size, 4711 , 'ENDS0 UDP size set');
$r->edns_size( 0 );
is($r->edns_size, 0 , 'ENDS0 UDP size set to zero');

is($r->timeout, 5, 'Expected default timeout');
$r->timeout(3.33);
is($r->timeout, 3.33, 'Expected set timeout');

subtest 'recursion' => sub {
    my $r = Net::LDNS->new( '8.8.4.4' );
    my $p1 = $r->query( 'www.iis.se' );
    is( scalar($p1->answer), 1);
    $r->recurse(0);
    my $p2 = $r->query( 'www.nic.se' );
    is( scalar($p2->answer), 0, 'Got a reply');
    ok(!$p2->rd, 'RD flag set');
};

subtest 'global' => sub {
    my $res = new_ok( 'Net::LDNS' );
    my $p   = eval { $res->query( 'www.iis.se' ) } ;
    plan skip_all => 'No response, cannot test' if not $p;

    isa_ok( $p, 'Net::LDNS::Packet' );
    isa_ok( $_, 'Net::LDNS::RR' ) for $p->answer;
};

subtest 'sections' => sub {
    my $res = Net::LDNS->new( '194.146.106.22' );
    my $p   = eval { $res->query( 'www.iis.se' ) };
    plan skip_all => 'No response, cannot test' if not $p;

    is( scalar( $p->answer ),     1, 'answer count in scalar context' );
    is( scalar( $p->authority ),  3, 'authority count in scalar context' );
    is( scalar( $p->additional ), 6, 'additional count in scalar context' );
    is( scalar( $p->question ),   1, 'question count in scalar context' );
};

subtest 'none' => sub {
    my $none = Net::LDNS->new( undef );
    isa_ok( $none, 'Net::LDNS' );
    my $pn = eval { $none->query( 'iis.se' ) };
    like( $@, qr/No \(valid\) nameservers defined in the resolver/ );
    ok( !$pn );
};

subtest 'broken' => sub {
    my $b0rken = eval { Net::LDNS->new( 'gurksallad' ) };
    ok( !$b0rken );
    like( $@, qr/Failed to parse IP address: gurksallad/ );
};

done_testing;
