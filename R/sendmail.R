## -*- truncate-lines: t; -*-

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
                     method = "default",
                     display.only = FALSE) {
    
    ## methods: blat, sendemail, outlook
    if (!is.null(body.file))
        body <- paste(readLines(body.file, encoding = encoding),
                      collapse = "\n")

    if (is.null(body))
        body <- "\n"
    else if (length(body) > 1L) {
        body <- paste0(body, collapse = "\n")
    }
    if (length(to) > 1L)
        to <- paste0(shQuote(to), collapse = ",")
    if (length(cc) > 1L)
        cc <- paste0(shQuote(cc), collapse = ",")
    if (length(bcc) > 1L)
        bcc <- paste0(shQuote(bcc), collapse = ",")

    ## if (inherits(body, "connection")) {
    ##     bdy <- paste0(" -o message-file=", summary(body)[["description"]])
    ## } else
    ##     bdy <- paste0(" -m ", sQuote(paste0(body, collapse = "\n")))

    if (method == "default") 
        method <- c(unix    = "sendemail",
                    windows = "blat")[.Platform$OS.type]
    
    if (method == "sendemail") {
        str <- paste0("sendemail -f ", shQuote(from),
                      if (!is.null(to))  paste0(" -t ", shQuote(to)) else "",
                      if (!is.null(cc))  paste0(" -cc ", shQuote(cc)) else "",
                      if (!is.null(bcc)) paste0(" -bcc ", shQuote(bcc)) else "",
                      if (!is.null(replyto)) paste0(" -o reply-to=", replyto) else "",
                      if (!is.null(logfile)) paste0(" -l ", logfile) else "",
                      " -u ", shQuote(subject),
                      " -m ", shQuote(body),
                      " -xu ", shQuote(user),
                      " -xp ", shQuote(password),
                      " -s ", paste0(server, ":", port),
                      " -o message-charset=utf-8")
        
        if (!is.null(attach))
            str <- paste0(str, " -a ", paste(attach, collapse = " "))
        if (!is.null(headers))
            str <- paste(str, paste0(" -o message-header=", shQuote(headers), collapse= ""))
        system(str)        
    } else if (method == "blat") {
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
        ## TODO use system2
        system(str)        
    } else if (method == "outlook") {
        
        cmd <- c("$o = New-Object -com Outlook.Application",
                 "$mail = $o.CreateItem(0)")
        cmd <- c(cmd,
                 paste("$mail.subject =", sQuote(subject)))
        if (!missing(to))
            cmd <- c(cmd,
                     paste("$mail.to =", sQuote(to)))
        if (!is.null(cc))
            cmd <- c(cmd,
                     paste("$mail.cc =", sQuote(to)))
        if (!is.null(bcc))
            cmd <- c(cmd,
                     paste("$mail.bcc =", sQuote(to)))
        if (!is.null(attach)) {
            for (a in attach)
                cmd <- if (file.exists(a))
                           c(cmd,
                             paste0("$mail.attachments.add(", sQuote(normalizePath(a)),")"))
                       else
                           stop("cannot find attachment ", sQuote(a))
        }
        cmd <- c(cmd,
                 paste("$mail.body =", sQuote(body)))
        if (display.only)
            cmd <- c(cmd, "$mail.display()")
        else
            cmd <- c(cmd, "$mail.send()")
        
        cmd <- paste(cmd, collapse = ";")
        system(paste("powershell -command ", shQuote(cmd)))
        

    } else
        stop("unknown method")
}
