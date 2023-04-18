/bin/bash

for smile in $(cat damn5.txt); do
    grep $smile ../smile/*.smi | cut -d: -f2 | while read smiles zinc_id; do
        echo $smiles $zinc_id
        /usr/local/bin/python3.7 $PROJECTS/BWILEYtest/test/DeepDockABL1/3d.py $smiles $zinc_id.sdf
done
done
