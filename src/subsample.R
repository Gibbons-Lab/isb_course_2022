#!/usr/bin/env Rscript

library(ShortRead)

subsample <- function(files, depth = round(runif(1, 18000, 22000))) {
    fq <- readFastq(files[1])
    rq <- readFastq(files[2])
    idx <- sample.int(length(fq), depth) |> sort()
    return(list(fq[idx], rq[idx]))
}

for (i in 1:3) {
    files <- c(
        sprintf("mephaa%d_R1.fastq.gz", i),
        sprintf("mephaa%d_R2.fastq.gz", i))
    cat(".")
    sampled <- subsample(file.path("old", files))
    writeFastq(sampled[[1]], file.path("data", files[1]))
    writeFastq(sampled[[2]], file.path("data", files[2]))
}
