//
// CHANNEL_SENTIEON_DEDUP_CREATE_CSV
//

workflow CHANNEL_SENTIEON_DEDUP_CREATE_CSV {
    take:
        cram_sentieon_dedup // channel: [mandatory] meta, cram, crai

    main:
        // Creating csv files to restart from this step
        cram_sentieon_dedup.collectFile(keepHeader: true, skip: 1, sort: true, storeDir: "${params.outdir}/csv") { meta, file, index ->
            patient        = meta.patient
            sample         = meta.sample
            sex            = meta.sex
            status         = meta.status
            suffix_aligned = params.save_output_as_bam ? "bam" : "cram"
            suffix_index   = params.save_output_as_bam ? "bam.bai" : "cram.crai"
            file   = "${params.outdir}/preprocessing/sentieon_dedup/${sample}/${file.baseName}.${suffix_aligned}"
            index   = "${params.outdir}/preprocessing/sentieon_dedup/${sample}/${index.baseName.minus(".cram")}.${suffix_index}"

            type = params.save_output_as_bam ? "bam" : "cram"
            type_index = params.save_output_as_bam ? "bai" : "crai"

            ["markduplicates_no_table.csv", "patient,sex,status,sample,${type},${type_index}\n${patient},${sex},${status},${sample},${file},${index}\n"]
        }
}
