\name{Attachments}
\alias{save_msg_attachments}
\title{
  Save Attachments of msg Files
}
\description{
  Save an attachments of Outlook msg files.
}
\usage{
save_msg_attachments(msg.path, pdf.path)
}

\arguments{
  \item{msg.path}{
    the attachment to find. Can be a regular expression.
  }
  \item{pdf.path}{
    the mbox file
  }

}
\details{
  
  The functions uses a simple PowerShell script to save attachments to
  msg files into separate files.

}
\value{
  
  The function is called for its side effect.

}
\author{
  Enrico Schumann
}
\examples{
## save_msg_attachments("~/Desktop", "~/Desktop/attachments")
}
