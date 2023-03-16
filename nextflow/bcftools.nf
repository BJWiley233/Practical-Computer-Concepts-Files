// Declare syntax version
nextflow.enable.dsl=2


process index_vcf {

    cpus 1
    memory { '2.GB' * task.attempt }

    container 'kboltonlab/bst:2.0'
    label "bcftools"

    tag "Processing ${input_vcf}"

    input:
        path input_vcf
        //path  reference

    output:
        //path("L002/L002.mri.tgz")
        path("${input_vcf.getBaseName(2)}.vcf.gz"), emit: vcf
        path("${input_vcf.getBaseName(2)}.vcf.gz.tbi"), emit: vcf_index

    script:
        """
        tabix $input_vcf
        """

}

process norm_vcf {

    cpus 1
    memory { '2.GB' * task.attempt }

    container 'kboltonlab/bst:2.0'
    label "bcftools"

    tag "Processing ${input_vcf}"

    debug true 

    input:
        //tuple path(input_vcf), path(input_vcf_index)
        path(input_vcf)
        path(input_vcf_index)
        path reference

    output:
        path("${input_vcf.getBaseName(2)}.norm.vcf.gz"), emit: vcf
        path("${input_vcf.getBaseName(2)}.norm.vcf.gz.tbi"), emit: vcf_index

    script:
        def ref = reference.name != 'NO_FILE' ? "-f $reference" : ''
        """
        output_vcf=\$(basename $input_vcf .vcf.gz).norm.vcf.gz
        bcftools norm -m -any $ref --threads 4 -Oz -o \$output_vcf $input_vcf
        tabix \$output_vcf
        """

}

process filter_vcf {

    cpus 1
    memory { '2.GB' * task.attempt }

    container 'kboltonlab/bst:2.0'
    label "bcftools"

    tag "Processing ${input_vcf}"

    debug true 

    input:
        //tuple path(input_vcf), path(input_vcf_index)
        path(input_vcf)
        path(input_vcf_index)

    output:
        path("${input_vcf.getBaseName(2)}.filtered.vcf.gz"), emit: vcf
        path("${input_vcf.getBaseName(2)}.filtered.vcf.gz.tbi"), emit: vcf_index

    script:
        def ref = reference.name != 'NO_FILE' ? "-f $reference" : ''
        """
        output_vcf=\$(basename $input_vcf .vcf.gz).filtered.vcf.gz
        bcftools filter --threads 4 -i 'FILTER=\"PASS\"' -Oz -o \$output_vcf $input_vcf
        tabix \$output_vcf
        """

}


params.input_csv
params.ref = 'NO_FILE'
params.sample

// input = Channel.fromPath(params.input_csv)
ref = Channel.fromPath(params.ref)
input = Channel.fromPath(params.input_csv)

workflow WF  {
    take:
        ref
        input
    main:
        input \
            | splitCsv(header:true) \
            | map { row-> file(row.vcf) }
            | index_vcf
        //norm_vcf( tuple(file(index_vcf.out.vcf), file(index_vcf.out.vcf_index)), ref )
        norm_vcf( index_vcf.out.vcf, index_vcf.out.vcf_index, ref )
    emit:
        vcf = norm_vcf.out.vcf
        vcf_index = norm_vcf.out.vcf_index
    
}

workflow FILTER {
    take:
        vcf
        vcf_index
    main:
        filter_vcf( vcf, vcf_index )
    emit:
        vcf = filter_vcf.out.vcf
        vcf_index = filter_vcf.out.vcf_index

}

workflow {
    publishDir params.sample

    WF(ref, input)
    FILTER(WF.out.vcf, WF.out.vcf_index)
    emit:
        final_vcf = FILTER.out.vcf
        final_vcf_index = FILTER.out.vcf_index
}

// workflow {
//     input = Channel.fromPath(params.input_csv)
//     ref = Channel.fromPath(params.ref)

//     MY_WF(ref, input)
//     //emit:
//         //norm_vcf.out
// }