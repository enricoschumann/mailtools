## -*- truncate-lines: t; -*-

sendmail <- function(subject,
                     body,
                     body.file = NULL,
                     to = NULL,
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
                     method = NULL,
                     display.only = FALSE,
                     html = FALSE,
                     tls = NULL,
                     SendUsingAccount) {

    old <- options(useFancyQuotes = FALSE)
    on.exit(options(old))

    method <- tolower(method)
    if (!is.null(body.file) && (is.null(method) || method != "outlook"))
        body <- paste(readLines(body.file, encoding = encoding),
                      collapse = "\n")

    if (!missing(body) && length(body) > 1L) {
        body <- paste0(body, collapse = "\n")
    }


    ## if (inherits(body, "connection")) {
    ##     bdy <- paste0(" -o message-file=", summary(body)[["description"]])
    ## } else
    ##     bdy <- paste0(" -m ", sQuote(paste0(body, collapse = "\n")))

    if (is.null(method)) {
        method <- c(unix    = "sendemail",
                    windows = "blat")[.Platform$OS.type]

    } else if (method == "sendemail") {

        if (!is.null(to))
            to <- paste0(shQuote(to), collapse = ",")
        if (!is.null(cc))
            cc <- paste0(shQuote(cc), collapse = ",")
        if (!is.null(bcc))
            bcc <- paste0(shQuote(bcc), collapse = ",")
        if (!is.null(replyto))
            replyto <- paste0(shQuote(replyto), collapse = ",")

        if (!is.null(tls)) {
            if (isTRUE(tls))
                tls <- "-o tls=yes"
            else if (isFALSE(tls)) {
                tls <- "-o tls=no"
            } else
                stop(sQuote("tls"), " should be either TRUE or FALSE")
        }

        str <- paste0("sendemail -f ", shQuote(from),
                      if (!is.null(to))  paste0(" -t ", to) else "",
                      if (!is.null(cc))  paste0(" -cc ", cc) else "",
                      if (!is.null(bcc)) paste0(" -bcc ", bcc) else "",
                      if (!is.null(replyto)) paste0(" -o reply-to=", replyto) else "",
                      if (!is.null(logfile)) paste0(" -l ", logfile) else "",
                      " -u ", shQuote(subject),
                      " -m ", shQuote(body),
                      " -xu ", shQuote(user),
                      " -xp ", shQuote(password),
                      " -s ", paste0(server, ":", port),
                      " -o message-charset=utf-8 ")
        str <- paste(str, tls)

        if (!is.null(attach))
            str <- paste0(str, " -a ", paste(attach, collapse = " "))
        if (!is.null(headers))
            str <- paste(str, paste0(" -o message-header=", shQuote(headers), collapse= ""))
        system(str)

    } else if (method == "blat") {
        ## TODO check handling of multiple recipients
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
        ## TODO use system2?
        system(str)
    } else if (method == "outlook") {

        if (!is.null(to))
            to <- paste0(to, collapse = ";")
        if (!is.null(cc))
            cc <- paste0(cc, collapse = ";")
        if (!is.null(bcc))
            bcc <- paste0(bcc, collapse = ";")
        if (!is.null(replyto))
            replyto <- paste0(replyto, collapse = ";")

        cmd <- c("$o = New-Object -com Outlook.Application",
                 "$mail = $o.CreateItem(0)")
        cmd <- c(cmd,
                 paste("$mail.subject =", sQuote(subject)))
        if (!is.null(to))
            cmd <- c(cmd,
                     paste("$mail.to =", sQuote(to)))
        if (!is.null(cc))
            cmd <- c(cmd,
                     paste("$mail.cc =", sQuote(cc)))
        if (!is.null(bcc))
            cmd <- c(cmd,
                     paste("$mail.bcc =", sQuote(bcc)))
        if (!is.null(attach)) {
            ## on Windows, a filename must not contain
            ## double-quotes, so doublequote filenames
            for (a in attach)
                cmd <- if (file.exists(a))
                           c(cmd,
                             paste0("$mail.attachments.add(",
                                    dQuote(normalizePath(a)), ")"))
                       else
                           stop("cannot find attachment ", sQuote(a))
        }

        if (!is.null(body.file)) {
            body <- paste("Get-Content -Path", sQuote(normalizePath(body.file)), "-Raw")
        } else
            body <- dQuote(body)

        cmd <- c(cmd,
                 paste(if (html) "$mail.HTMLBody =" else "$mail.Body =", body))
        if (!html)
            cmd <- c(cmd, "$mail.BodyFormat = 2")

        if (!missing(SendUsingAccount)) {
                l1 <- paste0("$acc = $o.Session.Accounts | ",
                             "Where-Object { $_.SmtpAddress -eq ",
                             shQuote(SendUsingAccount), " }")
                l2 <- paste0("[Void] $mail.GetType().InvokeMember(",
                             shQuote("SendUsingAccount"), ",",
                             shQuote("SetProperty"),
                             ", $NULL, $mail, $acc)")
                cmd <- c(cmd, l1, l2)
        }

        if (display.only)
            cmd <- c(cmd, "$mail.Display()")
        else
            cmd <- c(cmd, "$mail.Send()")
        ## cat(cmd, sep = "\n")
        cmd <- paste(cmd, collapse = ";")

        ans <- system(paste("powershell -command ",
                            shQuote(cmd)), intern = TRUE)
        attr(ans, "powershell.cmd") <- shQuote(cmd)
        invisible(ans)
    } else
        stop("unknown method")
}
