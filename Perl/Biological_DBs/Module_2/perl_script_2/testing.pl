use strict;

BEGIN {require 5.006;}

require Exporter;
use ExtUtils::MakeMaker::Config;
use ExtUtils::MakeMaker::version; # ensure we always have our fake version.pm
use Carp;
use File::Path;
my $CAN_DECODE = eval { require ExtUtils::MakeMaker::Locale; }; # 2 birds, 1 stone
eval { ExtUtils::MakeMaker::Locale::reinit('UTF-8') }
  if $CAN_DECODE and Encode::find_encoding('locale')->name eq 'ascii';

our $Verbose = 0;       # exported
our @Parent;            # needs to be localized
our @Get_from_Config;   # referenced by MM_Unix
our @MM_Sections;
our @Overridable;
my @Prepend_parent;
my %Recognized_Att_Keys;
our %macro_fsentity; # whether a macro is a filesystem name
our %macro_dep; # whether a macro is a dependency

our $VERSION = '7.24';
$VERSION = eval $VERSION;  ## no critic [BuiltinFunctions::ProhibitStringyEval]

# Emulate something resembling CVS $Revision$
(our $Revision = $VERSION) =~ s{_}{};
$Revision = int $Revision * 10000;

our $Filename = __FILE__;   # referenced outside MakeMaker

our @ISA = qw(Exporter);
our @EXPORT    = qw(&WriteMakefile $Verbose &prompt);
our @EXPORT_OK = qw($VERSION &neatvalue &mkbootstrap &mksymlists
                    &WriteEmptyMakefile &open_for_writing &write_file_via_tmp
                    &_sprintf562);

# These will go away once the last of the Win32 & VMS specific code is
# purged.
my $Is_VMS     = $^O eq 'VMS';
my $Is_Win32   = $^O eq 'MSWin32';

print $ENV{PERL_MM_OPT} . "\n";


env PERL_MM_OPT='INSTALL_BASE=/usr/share/perl/5.26.1' cpanm DBD::SQLite

cpanm -l /usr/share/perl/5.26.1 DBD::SQLite
