# This test was stolen from KinoSearch’s LCNormalizer tests and
# KinoTestUtils (with the appropriate modifications).

use strict;
use warnings;
use utf8;

use Test::More tests => 5;

use_ok 'KSx::Analysis::StripAccents';

my $stripper = KSx::Analysis::StripAccents->new;

test_analyzer(
    $stripper,      "căPîTāl ofḞḕnsE",
    ['capital offense'], 'lc plain text'
);

# Verify an Analyzer's analyze_batch, analyze_field, analyze_text, and analyze_raw methods.
sub test_analyzer {
    my ( $analyzer, $source, $expected, $message ) = @_;

    require KinoSearch::Analysis::TokenBatch;
    my $batch = KinoSearch::Analysis::TokenBatch->new( text => $source );
    $batch = $analyzer->analyze_batch($batch);
    my @got;
    while ( my $token = $batch->next ) {
        push @got, $token->get_text;
    }
    Test::More::is_deeply( \@got, $expected, "analyze: $message" );

    $batch = $analyzer->analyze_text($source);
    @got   = ();
    while ( my $token = $batch->next ) {
        push @got, $token->get_text;
    }
    Test::More::is_deeply( \@got, $expected, "analyze_text: $message" );

    @got = $analyzer->analyze_raw($source);
    Test::More::is_deeply( \@got, $expected, "analyze_raw: $message" );

    $batch = $analyzer->analyze_field(
        KinoSearch::Doc->new( fields => { content => $source } ), 'content' );
    @got = ();
    while ( my $token = $batch->next ) {
        push @got, $token->get_text;
    }
    Test::More::is_deeply( \@got, $expected, "analyze_field: $message" );
}

