\name{sendmail}
\alias{sendmail}
\title{
  Send Emails
}
\description{
  Send emails via command line tools.
}
\usage{
sendmail(subject, body, body.file = NULL, to = NULL, from,
         cc = NULL, bcc = NULL, replyto = NULL,
         server, port, user, password,
         attach = NULL, signature = NULL, signature.file = NULL,
         headers = NULL, wait = TRUE, logfile = NULL,
         encoding = "unknown", method = NULL,
         display.only = FALSE, html = FALSE, SendUsingAccount)
}
\arguments{
  \item{subject}{
    character
}
  \item{body}{
    character. When of length > 1, then all elements are
    pasted together, separated by newline characters
}
  \item{body.file}{
    character. If specified, \code{body} is ignored.
}
  \item{to}{
    character
}
  \item{from}{
    character
}
  \item{cc}{
    character
}
  \item{bcc}{
    character
}
  \item{replyto}{
    character
}
  \item{server}{
    character
}
  \item{port}{
    character (an integer will automatically be coerced). Typically 587.
}
  \item{user}{
    character
}
  \item{password}{
    character
}
  \item{attach}{
    character
}
  \item{signature}{
    character
}
  \item{signature.file}{
    character. Name of file.
}
  \item{headers}{
    a character vector of header lines (i.e. for more than one
    header use \code{c(....)})
}
  \item{wait}{
    logical
}
  \item{logfile}{
    character
}
  \item{encoding}{
    character
}
  \item{method}{
    the programme to be called.
}
  \item{display.only}{

    logical: if \code{TRUE}, only display message, but
    do not send. Works only for method \code{outlook}.

  }
  \item{html}{

    logical: send as HTML? For method \code{sendemail},
    if the message body begins with \code{<html>}, it
    is considered HTML.

  }
  \item{SendUsingAccount}{

    a character string: an email address.
    only supported for method \sQuote{\code{outlook}}.
  }

}
\details{

  The function provides a wrapper for different tools
  that send emails. In this way, the same \R code that
  can be used across platforms, provided a suitable
  backend is installed.

  The function constructs an invocation of a
  command-line utility, specified by \code{method}, and
  then calls the specified method via
  \code{system}. Currently supported are \code{sendemail} and
  \code{Blat} (see References).

}
\value{

  the return value of \code{system}

}
\references{

  \url{http://caspian.dotconf.net/menu/Software/SendEmail/}

  \url{https://www.blat.net/}

  \acronym{RFC} 2822: Internet Message Format.
  \url{https://tools.ietf.org/html/rfc2822}

}
\author{
  Enrico Schumann
}
\examples{
\dontrun{
body <- "
<p>Hello.</p>

  <p>Please do not send <b>spam</b></p>.
"

sendmail(subject  = "Greetings",
         body     = "Hello",
         to       = "testing@testing.org",
         method   = "outlook",
         html     = TRUE,
         display.only = TRUE)  ## only open mail in Outlook
}
}
