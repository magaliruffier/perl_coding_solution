# Install Core API using the instructions listed here- https://grch37.ensembl.org/info/docs/api/api_installation.html
# Perl version 5.22.1

# Another solution is given below.
# Advantage- 
# 1. Easy to use
# 2. Identifies length mismatch and any fragments in the projected segment. 
# Disadvantage-
# 1. Only projects the feature in question. Does not project any of the other features associated with the region.

use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Utils::AssemblyProjector;

my $dba = new Bio::EnsEMBL::DBSQL::DBAdaptor(
    -host   => 'ensembldb.ensembl.org',
    -port   => 3306,
    -user   => anonymous,
    -dbname => 'homo_sapiens_core_95_38',
    -group  => 'core',
  );

my $assembly_projector = Bio::EnsEMBL::Utils::AssemblyProjector->new(
    -OLD_ASSEMBLY    => 'GRCh38',
    -NEW_ASSEMBLY    => 'GRCh37',
    -ADAPTOR         => $dba,
    -EXTERNAL_SOURCE => 1,
    -MERGE_FRAGMENTS => 1,
    -CHECK_LENGTH    => 0,
);

my $slice_adaptor = $dba->get_SliceAdaptor;

my $old_slice = $slice_adaptor->fetch_by_region( 'chromosome', 10, 25000, 30000, undef, 'GRCh38' );
print $old_slice->name, " (", $assembly_projector->last_status, ")\n";

my $new_slice = $assembly_projector->project($old_slice, 'GRCh37');
print $new_slice->name, " (", $assembly_projector->last_status, ")\n";

