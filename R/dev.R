if (FALSE) {
                                        #! /usr/bin/Rscript --vanilla
    fun <- function(x) {
        tmp <- lapply(strsplit(x, "", fixed = TRUE),
                      function(x) sort(unique(x)))
        tmp <- unlist(lapply(tmp,
                             paste, collapse = ""))
        paste0("2,", tmp)
    }


    longf <- dir("/home/es/MailOI/EStest/",
                 recursive = TRUE, full.names = TRUE)
    uniq <- gsub(".*/(.*?):.*", "\\1", longf)
    info <- gsub(".*/.*?:(.*)", "\\1", longf)
    ##file.remove(longf[duplicated(uniq)])

    ## correct info
    correct.info <- fun(gsub("[^A-Z]", "", info))
    rnm <- correct.info != info

    file.rename(longf[rnm],
                paste0(gsub("(.*/.*?:).*", "\\1", longf[rnm]), correct.info[rnm]))

    ## check expiry
    inbox <- dir("/home/es/MailOI/EStest/INBOX/cur",
                 recursive = TRUE, full.names = TRUE)

    for (f in inbox) {
        msg <- readLines(f)
        if (length(line <- grep("^X-es-expiry: +[0-9]+-[0-9]+-[0-9]+", msg)))
            if (as.Date(gsub("^X-es-expiry: +([0-9]+-[0-9]+-[0-9]+)", "\\1", msg[line])) <=
                Sys.Date()+5) {
                if (file.remove(f))
                    message("removed file ", f)
                
            }
    }
}
