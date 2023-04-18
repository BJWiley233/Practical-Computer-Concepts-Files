
# HG2 HG3
# ARG ARGN GLN QLN GLU PGLU GLUH LYS LYSH MET PRO

# HB2 HB3
# ARG ARGN ASN ASP ASPH CYS CYX CYSH GLN QLN GLU PGLU GLUH LYS LYSH MET PRO HIS LEU PHE SER TRP TYR

# HD2 HD3
# ARG ARGN LYS LYSH PRO

# HE2 HE3
# LYS LYSH
echo GROMACSPDB.sh in.pdb out.pdb CHARMM
# pdb_file=Q00534_fill.BL00010001_ligand_conect.fixed.out.pdb_3
pdb_file=$1
out_file=$2
ff=$3
echo $out_file
echo $ff

sed 's/HG2 ARG/HG1 ARG/g' $pdb_file | \
   sed 's/HG2 ARGN/HG1 ARGN/g' | \
   sed 's/HG2 GLN/HG1 GLN/g' | \
   sed 's/HG2 QLN/HG1 QLN/g' | \
   sed 's/HG2 GLU/HG1 GLU/g' | \
   sed 's/HG2 PGLU/HG1 PGLU/g' | \
   sed 's/HG2 GLH/HG1 GLH/g' | \
   sed 's/HG2 LYS/HG1 LYS/g' | \
   sed 's/HG2 LYSH/HG1 LYSH/g' | \
   sed 's/HG2 MET/HG1 MET/g' | \
   sed 's/HG2 PRO/HG1 PRO/g' | \

   sed 's/HG3 ARG/HG2 ARG/g' | \
   sed 's/HG3 ARGN/HG2 ARGN/g' | \
   sed 's/HG3 GLN/HG2 GLN/g' | \
   sed 's/HG3 QLN/HG2 QLN/g' | \
   sed 's/HG3 GLU/HG2 GLU/g' | \
   sed 's/HG3 PGLU/HG2 PGLU/g' | \
   sed 's/HG3 GLH/HG2 GLH/g' | \
   sed 's/HG3 LYS/HG2 LYS/g' | \
   sed 's/HG3 LYSH/HG2 LYSH/g' | \
   sed 's/HG3 MET/HG2 MET/g' | \
   sed 's/HG3 PRO/HG2 PRO/g' | \

   sed 's/HB2 ARG/HB1 ARG/g' | \
   sed 's/HB2 ARGN/HB1 ARGN/g' | \
   sed 's/HB2 GLN/HB1 GLN/g' | \
   sed 's/HB2 QLN/HB1 QLN/g' | \
   sed 's/HB2 GLU/HB1 GLU/g' | \
   sed 's/HB2 PGLU/HB1 PGLU/g' | \
   sed 's/HB2 GLH/HB1 GLH/g' | \
   sed 's/HB2 LYS/HB1 LYS/g' | \
   sed 's/HB2 LYSH/HB1 LYSH/g' | \
   sed 's/HB2 MET/HB1 MET/g' | \
   sed 's/HB2 PRO/HB1 PRO/g' | \
   sed 's/HB2 ASN/HB1 ASN/g' | \
   sed 's/HB2 ASP/HB1 ASP/g' | \
   sed 's/HB2 ASH/HB1 ASH/g' | \
   sed 's/HB2 CYS/HB1 CYS/g' | \
   sed 's/HB2 CYX/HB1 CYX/g' | \
   sed 's/HB2 CYSH/HB1 CYSH/g' | \
   sed 's/HB2 HIS/HB1 HIS/g' | \
   sed 's/HB2 LEU/HB1 LEU/g' | \
   sed 's/HB2 PHE/HB1 PHE/g' | \
   sed 's/HB2 SER/HB1 SER/g' | \
   sed 's/HB2 TRP/HB1 TRP/g' | \
   sed 's/HB2 TYR/HB1 TYR/g' | \

   sed 's/HB3 ARG/HB2 ARG/g' | \
   sed 's/HB3 ARGN/HB2 ARGN/g' | \
   sed 's/HB3 GLN/HB2 GLN/g' | \
   sed 's/HB3 QLN/HB2 QLN/g' | \
   sed 's/HB3 GLU/HB2 GLU/g' | \
   sed 's/HB3 PGLU/HB2 PGLU/g' | \
   sed 's/HB3 GLH/HB2 GLH/g' | \
   sed 's/HB3 LYS/HB2 LYS/g' | \
   sed 's/HB3 LYSH/HB2 LYSH/g' | \
   sed 's/HB3 MET/HB2 MET/g' | \
   sed 's/HB3 PRO/HB2 PRO/g' | \
   sed 's/HB3 ASN/HB2 ASN/g' | \
   sed 's/HB3 ASP/HB2 ASP/g' | \
   sed 's/HB3 ASH/HB2 ASH/g' | \
   sed 's/HB3 CYS/HB2 CYS/g' | \
   sed 's/HB3 CYX/HB2 CYX/g' | \
   sed 's/HB3 CYSH/HB2 CYSH/g' | \
   sed 's/HB3 HIS/HB2 HIS/g' | \
   sed 's/HB3 LEU/HB2 LEU/g' | \
   sed 's/HB3 PHE/HB2 PHE/g' | \
   sed 's/HB3 SER/HB2 SER/g' | \
   sed 's/HB3 TRP/HB2 TRP/g' | \
   sed 's/HB3 TYR/HB2 TYR/g' | \

   sed 's/HD2 ARG/HD1 ARG/g' | \
   sed 's/HD2 ARGN/HD1 ARGN/g' | \
   sed 's/HD2 LYS/HD1 LYS/g' | \
   sed 's/HD2 LYSH/HD1 LYSH/g' | \
   sed 's/HD2 PRO/HD1 PRO/g' | \

   sed 's/HD3 ARG/HD2 ARG/g' | \
   sed 's/HD3 ARGN/HD2 ARGN/g' | \
   sed 's/HD3 LYS/HD2 LYS/g' | \
   sed 's/HD3 LYSH/HD2 LYSH/g' | \
   sed 's/HD3 PRO/HD2 PRO/g' | \

   sed 's/HE2 LYS/HE1 LYS/g' | \
   sed 's/HE2 LYSH/HE1 LYSH/g' | \
   sed 's/HE3 LYS/HE2 LYS/g' | \
   sed 's/HE3 LYSH/HE2 LYSH/g' | \

   sed 's/HG12 ILE/HG11 ILE/g' | \
   sed 's/HG13 ILE/HG12 ILE/g' | \
   
   sed 's/HA2 GLY/HA1 GLY/g' | \
   sed 's/HA3 GLY/HA2 GLY/g' | grep -v HETATM | grep -v CONECT > tmp.pdb

## is both `HE2 HIS` and `HD1 HIS` then HIP (Tinker)
# /Users/brian/books/chem430/gromacs_tutorials/Ribociclib/Q00534_fill.BL00010001_ligand_conect.fixed.out.pdb_3
if [[ $ff != 'CHARMM' ]]; then
   echo NOT CHARMM...
   if [[ $(grep "HE2 HIS" $pdb_file | wc -l) -gt 0 && $(grep "HD1 HIS" $pdb_file | wc -l) -gt 0 ]]; then
      # could be a mixture from Rosetta
   
      echo HIP
      sed 's/HIS /HISH/g' tmp.pdb > $out_file
   ## pdbfixer and pdb2pqr
   ## only `HD1 HIS` then HID
   # pdb_file=/Users/brian/books/chem430/gromacs_tutorials/Ribociclib/test/6YZ4.fixed.pdb
   elif [[ $(grep "HD1 HIS" $pdb_file | wc -l) -gt 0 ]]; then
      echo HID
      sed 's/HIS /HISD/g' tmp.pdb > $out_file
   ## only `HE2 HIS` then HIE (default HIS for GROMACs)
   elif [[ $(grep "HE2 HIS" $pdb_file | wc -l) -gt 0 ]]; then
      #echo HIS/HIE no change
      continue
      # charm GUI updated
   else
      #sed 's/HG  SER/HG1 SER/g' tmp.pdb | sed 's/HG  CYS/HG1 CYS/g' > $out_file
      sed 's/HG1 SER/HG  SER/g' tmp.pdb | sed 's/HG1 CYS/HG  CYS/g'  > $out_file
   fi
else 
   echo CHARMM
   if [[ $(grep "HE2 HIS" $pdb_file | wc -l) -gt 0 ]]; then
      echo HSP
      sed 's/HIS /HISH/g' tmp.pdb > tmp.pdb2 && mv tmp.pdb2 tmp.pdb
   elif [[ $(grep "HD1 HIS" $pdb_file | wc -l) -gt 0 ]]; then
      echo HSD
      sed 's/HIS /HISD/g' tmp.pdb > tmp.pdb2 && mv tmp.pdb2 tmp.pdb
   fi
   sed 's/HG  SER/HG1 SER/g' tmp.pdb | sed 's/HG  CYS/HG1 CYS/g' > $out_file
fi

rm tmp.pdb
