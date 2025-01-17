# =========================================================================================================
#     Assemble reads with k-mers
# =========================================================================================================

rule spades:
    input: 
        R1= "results/fetch_reads_with_kmers/{phenos_filt}/reads_with_kmers_from_all_acc_sorted_R1.fastq",
        R2= "results/fetch_reads_with_kmers/{phenos_filt}/reads_with_kmers_from_all_acc_sorted_R2.fastq"
    output:
        contigs= "results/assemble_reads_with_kmers/{phenos_filt}/assembly/contigs.fasta",
        graph= "results/assemble_reads_with_kmers/{phenos_filt}/assembly/assembly_graph_with_scaffolds.gfa",
    conda:
        "../envs/assemble_reads.yaml"
    threads: 
        config["params"]["spades"]["threads"]
    params:
        out_dir = lambda w, output: os.path.dirname(output.contigs),
        extra = config["params"]["spades"]["extra"]
    log:
        "logs/assemble_reads/{phenos_filt}/assemble_reads.spades.log"
    shell:
        """
        spades.py --careful --only-assembler -t {threads} {params.extra} --pe1-1 {input.R1} --pe1-2 {input.R2} -o {params.out_dir} 2> {log}
        """

# =========================================================================================================
