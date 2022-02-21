#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { EUKULELE             } from '../../../modules/eukulele/main.nf'

process STAGE_FASTA_DIR {
    input:
    tuple val(meta), path(fasta_file)

    output:
    tuple val(meta), path('genome'), emit: fasta_dir

    script:
    """
    mkdir genome
    mv ${fasta_file} genome
    """
}

workflow test_eukulele {
    
    input = [ 
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true) 
    ]
    
    STAGE_FASTA_DIR ( input )

    EUKULELE        ( STAGE_FASTA_DIR.out.fasta_dir )
}
