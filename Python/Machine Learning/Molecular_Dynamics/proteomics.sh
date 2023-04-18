mono MaxQuant/bin/MaxQuantCmd.exe mqpar.xml

Tryptic peptides were individually synthesized by solid phase synthesis, combined into pools of ~1,000 peptides and measured on an Orbitrap Fusion mass spectrometer. For each peptide pool, an inclusion list was generated to target peptides for fragmentation in further LC-MS experiments using five fragmentation methods (HCD, CID, ETD, EThCD, ETciD ) with ion trap or Orbitrap readout and HCD spectra...
# https://support.proteomesoftware.com/hc/en-us/articles/115000616243-CID-ETD-HCD-and-Other-Fragmentation-Modes-in-Scaffold
    HCD - Higher Energy Collision Induced Dissociation
    CID - Collision Induced Dissociation
    ETD - Electron Transfer Dissociation
    EThCD - hybrid of ETD and HCD
    ETciD - hybrid of ETD and CID
    DDA - Data Dependent Acuisition

https://www.ebi.ac.uk/pride/archive/projects/PXD004732
ftp ftp://ftp.pride.ebi.ac.uk/pride-archive/2017/02/
cd PXD004732/
ls *Thermo_SRM_Pool_75_01_01*
for i in Thermo_SRM_Pool_75_01_01-2xIT_2xHCD-1h-R2.raw Thermo_SRM_Pool_75_01_01-3xHCD-1h-R2.raw Thermo_SRM_Pool_75_01_01-DDA-1h-R2.raw; do
  folder=$(basename $i .raw)
  mkdir $folder
  ftp ftp://ftp.pride.ebi.ac.uk/pride-archive/2017/02/PXD004732/01640c_BC10-${i} > $folder.log 2>&1 &
done
wait

for i in Thermo_SRM_Pool_75_01_01-2xIT_2xHCD-1h-R2.raw Thermo_SRM_Pool_75_01_01-3xHCD-1h-R2.raw Thermo_SRM_Pool_75_01_01-DDA-1h-R2.raw Thermo_SRM_Pool_75_01_01-ETD-1h-R2.raw; do
  folder=$(basename $i .raw)
  mkdir $folder
  ftp ftp://ftp.pride.ebi.ac.uk/pride-archive/2017/02/PXD004732/01640c_BC10-${i} > $i.log 2>&1 &
  ftp ftp.pride.ebi.ac.uk/pride-archive/2017/02/PXD004732/01640c_BC10-${i} > $i.log 2>&1 &
done
ncftp ftp://ftp.pride.ebi.ac.uk/pride-archive/2017/02/PXD004732/01640c_BC10-Thermo_SRM_Pool_75_01_01-ETD-1h-R2.raw

dir=`pwd`
for i in Thermo_SRM_Pool_75_01_01-2xIT_2xHCD-1h-R2.raw Thermo_SRM_Pool_75_01_01-3xHCD-1h-R2.raw Thermo_SRM_Pool_75_01_01-DDA-1h-R2.raw Thermo_SRM_Pool_75_01_01-ETD-1h-R2.raw; do
  folder=$(basename $i .raw)
  cd $dir
  mkdir -p $folder
  cd $folder
  ncftpget ftp://ftp.pride.ebi.ac.uk/pride-archive/2017/02/PXD004732/01640c_BC10-${i} > $i.log 2>&1 &
done

#MS/MS tol. (FTMS)	20 ppm
<Name>FTMS</Name>
         <MatchTolerance>20</MatchTolerance>
         <MatchToleranceInPpm>True</MatchToleranceInPpm>
ppm (parts per million)
Fourier transform mass spectrometry (FTMS) 


 <msmsParamsArray>
      <msmsParams>
         <Name>FTMS</Name>


  #Top MS/MS peaks per 100 Da. (FTMS)	12
  <Topx>12</Topx>
    <TopxInterval>100</TopxInterval>

    filtered peaks – top N peaks per 100 Da (peaks which are to be used for
    database search after processing the raw MS/MS spectrum, sensitive parameter
    for accessing the instrument performance, identified spectra: have much more
    filtered peaks than unidentified spectra, reason for that not completely clear) 



Total 605 peptides
missing 245 from ETD
missing only 63 from DDA