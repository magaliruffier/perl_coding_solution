# Install Core API using the instructions listed here- https://grch37.ensembl.org/info/docs/api/api_installation.html
# Perl version 5.22.1

use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Analysis;
use Bio::EnsEMBL::Feature;

my $db = new Bio::EnsEMBL::DBSQL::DBAdaptor(
    -host   => 'ensembldb.ensembl.org',
    -port   => 3306,
    -user   => anonymous,
    -dbname => 'homo_sapiens_core_95_38',
    -group  => 'core',
);

my $slice_adaptor = $db->get_SliceAdaptor;

my $old_slice = $slice_adaptor->fetch_by_region('chromosome', 10, 25000, 30000, undef, 'GRCh38');

my $analysis = Bio::EnsEMBL::Analysis->new(-LOGIC_NAME => 'test');

my $feature = Bio::EnsEMBL::Feature->new(-START => 1,
                                         -END   => 5000,
                                         -STRAND => 1,
                                         -ANALYSIS => $analysis,
                                         -SLICE => $old_slice);


my $chr_projection = $feature->project('chromosome', 'GRCh37');
foreach my $seg (@$chr_projection) {
      my $new_slice = $seg->to_Slice();
      print "Old slice coords ", $seg->from_start, '-',
        $seg->from_end, " project onto coords " .
        $new_slice->seq_region_name, ':', $new_slice->start, '-', $new_slice->end, "\n";
}

