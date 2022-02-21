process EUKULELE {
    tag "$meta.id"
    label 'process_medium'
    
    conda (params.enable_conda ? "bioconda::eukulele=1.0.6-0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/eukulele:1.0.6--pyh723bec7_0' :
        'quay.io/biocontainers/eukulele:1.0.6--pyh723bec7_0' }"

    input:
    tuple val(meta), path(contigs_fasta)

    output:
    tuple val(meta), path("${meta.id}/taxonomy_estimation/metat-estimated-taxonomy.out"), emit: taxonomy_extimation
    tuple val(meta), path("${meta.id}/taxonomy_counts/output_all_*_counts.csv")         , emit: taxonomy_counts
    tuple val(meta), path("${meta.id}/mets_full/diamond/metat.diamond.out.gz")          , emit: diamond
    
    path "versions.yml"                                                                 , emit: versions

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    
    """
    EUKulele \\
        $args \\
        -m mets \\
        -o $prefix \\
        --database /home/dadiaa/modules/tests/modules/eukulele/phylodb \\
        -s \\
        $contigs_fasta

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        eukulele: \$(echo \$(eukulele --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' ))
    END_VERSIONS
    """
}
