msgID <- function() {
    digits <- function(k, b) {
        if (all(k == 0L))
            return(rep(0, length(k)))
        nd <- 1 + floor(log(max(k), b))
        ans <- numeric(length(k) * nd)
        dim(ans) <- c(length(k), nd)
        for (i in nd:1) {
            ans[ ,i] <- k %% b
            if (i > 1L)
                k <- k%/%b
        }
        ans
    }
    ab <- c(1:9, 0,letters[1:26])    
    n <- c(floor(runif(1)*1e16),
           floor(10000*as.numeric(Sys.time())))
    paste(c(ab[digits(n[1L], 36) + 1], ".",
            ab[digits(n[2L], 36) + 1]), sep = "", collapse="")
}
