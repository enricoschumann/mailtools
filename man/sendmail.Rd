\name{sendmail}
\alias{sendmail}
\title{
  Send Emails
}
\description{
  Send emails via command line tools.
}
\usage{
sendmail(subject, body, body.file = NULL, to, from,
         cc = NULL, bcc = NULL, replyto = NULL,
         server, port, user, password,
         attach = NULL, signature = NULL, signature.file = NULL,
         headers = NULL, wait = TRUE, logfile = NULL,
         encoding = "unknown", method = "default")
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
    character
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
    a character vector of header lines
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
}
\details{

  The function constructs an invocation of a command-line utility,
  specified by \code{method}, and then calls the specified method via
  \code{system}. Currently supported are sendemail (default for
  Unix-like systems) and Blat.
  
}
\value{
  return value of \code{system}
}
\references{
  to be added
}
\author{
  Enrico Schumann
}
\section{Important}{
  The function uses command-line tools.
}
\seealso{
to be added
}
\examples{
## to be added
}
