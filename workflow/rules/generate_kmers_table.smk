# =================================================================================================
#     Create the k-mers table
#     # Source code of 'build_kmers_table': https://github.com/voichek/kmersGWAS
# =================================================================================================

rule create_kmers_table:
    input:
        list_paths = rules.generate_kmers_list_paths.output,
        kmers_count =expand("results/kmers_count/{u.sample_name}/kmers_with_strand", u=samples.itertuples()),
        kmers_to_use = rules.combine_and_filter.output.kmers_to_use,
        kmersGWAS_bin = rules.extract_kmersGWAS.output.kmersGWAS_bin,
    output:
        "results/kmers_table/kmers_table.table"
    params:
        prefix = lambda w, output: os.path.splitext(output[0])[0],
        kmer_len = config["params"]["kmc"]["kmer_len"],
    conda:
        "../envs/kmers_gwas.yaml"
    log:
        "logs/create_kmers_table/build_kmers_table.log"
    message:
        "Creating the k-mers table that contains the presence absence/pattern of the k-mers..."
    shell:
        """
        export LD_LIBRARY_PATH=$CONDA_PREFIX/lib
        
        {input.kmersGWAS_bin}/build_kmers_table -l {input.list_paths} -k {params.kmer_len} \
        -a {input.kmers_to_use} -o {params.prefix} 2> {log}
        """

# =================================================================================================
#     TODO: Convert the k-mers table to PLINK binary file
# =================================================================================================