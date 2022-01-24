#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { TRANSDECODER } from '../../../../modules/transdecoder/longorf/main.nf'

workflow test_transdecoder {
    
    input = [ 
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true) 
    ]

    TRANSDECODER ( input )
}
