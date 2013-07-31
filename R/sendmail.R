sendemail <- function(subject,
                      body,
                      to,
                      cc = NULL,
                      bcc = NULL,
                      f,
                      replyto = NULL,
                      port, server,
                      u, pw,
                      attach = NULL,
                      log = NULL,
                      wait = TRUE,
                      encoding = "unknown",
                      method= "sendemail") {

    ## methods: blat, sendemail

    if (inherits(body, "connection"))
        body <- paste(readLines("guvrep.txt", encoding = encoding),
                      collapse="\n")

    str <- paste0("sendemail -f ", f,
                  " -t ", to ,
                  " -cc ", cc ,
                  " -u ", sQuote(subject),
                  " -m ", sQuote(body),
                  " -xu ", u,
                  " -xp ", pw,
                  " -s ", paste0(server, ":", port))

    if (!is.null(attach))
        str <- paste0(str, " -a ", paste(attach, collapse = " "))

    system(str)
}
