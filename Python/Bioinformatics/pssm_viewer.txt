Task create python, perl or R script to parse Scoremat.asn file from PSI-BLAST:

pssm_viewer.cgi 
https://www.ncbi.nlm.nih.gov/Class/Structure/pssm/pssm_viewer.cgi

Hi Brian,

Unfortunately I don’t know how pssm_viewer.cgi does the mapping (perhaps info@ncbi.nlm.nih.gov may be able to direct you to someone who knows), but the order of amino acids is listed in the array NCBISTDAA_TO_AMINOACID (see definition below).
https://www.ncbi.nlm.nih.gov/IEB/ToolBox/CPP_DOC/lxr/source/src/algo/blast/core/blast_encoding.c#L115
I hope this helps, regards,

--
Christiam Camacho
NCBI/NLM/NIH [Contractor]
