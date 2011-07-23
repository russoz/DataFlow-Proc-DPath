
use Test::More tests => 9;

BEGIN {
    use_ok('DataFlow::Proc::DPath');
}

my $fail = eval q{DataFlow::Proc::DPath->new};
ok($@);

my $ok = DataFlow::Proc::DPath->new( search_dpath => '//*[2]' );
ok($ok);

my $data = {
    aList => [qw/aa bb cc dd ee ff gg hh ii jj/],
    aHash => {
        apple  => 'pie',
        banana => 'split',
        potato => [qw(baked chips fries fish&chips mashed)],
    },
};

sub pick {
    my $dpath = shift;
    my @res   = dpath($dpath)->match($data);
    return @res;
}

is_deeply( pick('/aList'), [qw/aa bb cc dd ee ff gg hh ii jj/], 'list' );
is_deeply( pick('/aList/*[2]'), 'cc', 'list element' );
is_deeply(
    [ pick('//*[3]') ],
    [qw/dd fish&chips/], 'all 4th elements of all lists',
);
is_deeply(
    { pick('/aHash') },
    {
        apple  => 'pie',
        banana => 'split',
        potato => [qw(baked chips fries fish&chips mashed)],
    },
    'hash'
);
is_deeply(
    [ pick('//*[ value =~ /i/ ]') ],
    [qw/split pie ii chips fries fish&chips/],
    q{elements with letter 'i'}
);
is_deeply(
    [ pick('//*[ value =~ /f/ ]') ],
    [qw/ff fries fish&chips/],
    q{elements with letter 'f'}
);

#say '::: tweaking list element';
#my @elem = dpathr('/aList/*[2]')->match($data);
#say @elem;
#${ $elem[0] } = 'WAKAWAKAWAKA';
#p @elem;
#pick( 'list after tweaking', '/aList' );

