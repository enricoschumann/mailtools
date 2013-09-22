sendmail <- function(subject,
                     body,
                     body.file = NULL,
                     to,
                     from,
                     cc = NULL,
                     bcc = NULL,
                     replyto = NULL,
                     server, port,
                     user, password,
                     attach = NULL,
                     signature = NULL,
                     signature.file = NULL,
                     headers = NULL,
                     wait = TRUE,
                     logfile = NULL,
                     encoding = "unknown",
                     method = "default") {
    
    ## methods: blat, sendemail
    if (!is.null(body.file))
        body <- paste(readLines(body.file, encoding = encoding),
                      collapse = "\n")

    if (is.null(body))
        body <- "\n"
    ## if (inherits(body, "connection")) {
    ##     bdy <- paste0(" -o message-file=", summary(body)[["description"]])
    ## } else
    ##     bdy <- paste0(" -m ", sQuote(paste0(body, collapse = "\n")))

    if (method == "default") 
        method <- c(unix    = "sendemail",
                    windows = "blat")[.Platform$OS.type]
    
    if (method == "sendemail") {
        str <- paste0("sendemail -f ", shQuote(from),
                      if (!is.null(to))  paste0(" -t ", to) else "",
                      if (!is.null(cc))  paste0(" -cc ", cc) else "",
                      if (!is.null(bcc)) paste0(" -bcc ", bcc) else "",
                      if (!is.null(replyto)) paste0(" -o reply-to=", replyto) else "",
                      if (!is.null(logfile)) paste0(" -l ", logfile) else "",
                      " -u ", shQuote(subject),
                      " -m ", shQuote(body),
                      " -xu ", user,
                      " -xp ", password,
                      " -s ", paste0(server, ":", port),
                      " -o message-charset=utf-8")
        
        if (!is.null(attach))
            str <- paste0(str, " -a ", paste(attach, collapse = " "))
        if (!is.null(headers))
            str <- paste(str, paste0(" -o message-header=", shQuote(headers), collapse= ""))
        system(str)        
    }


}
