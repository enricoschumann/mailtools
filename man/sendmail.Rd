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
    character
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
 To be added.
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
\section{Important }{
  The function uses command-line tools.
}
\seealso{
to be added
}
\examples{
## to be added
}
