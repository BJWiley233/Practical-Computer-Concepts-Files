$TOOLS/sdf2xyz2sdf-1.05/src/sdf2tinkerxyz -k final.key < trilaciclib_vina_out_best_hyd.sdf
cp ../final.xyz final.xyz_2 # shit!!
mkdir ../ligpargen
$TOOLS/sdf2xyz2sdf-1.05/src/tinkerxyz2sdf < trilaciclib_vina_out_best_hyd.sdf > ../ligpargen/trilaciclib.poltype.opt.sdf