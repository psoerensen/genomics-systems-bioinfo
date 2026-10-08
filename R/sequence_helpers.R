# Small teaching helpers; no database searching or production aligner.
read_teaching_fasta <- function(lines) {
  lines <- trimws(lines)
  lines <- lines[nzchar(lines)]
  headers <- which(startsWith(lines, ">"))
  stopifnot(length(headers)>0, headers[1]==1)
  ends <- c(headers[-1]-1, length(lines))
  id <- substring(lines[headers],2)
  stopifnot(all(nzchar(id)), !anyDuplicated(id), all(ends>headers))
  seq <- vapply(seq_along(headers), function(i)
    toupper(paste(lines[(headers[i]+1):ends[i]],collapse="")), character(1))
  stopifnot(all(grepl("^[ACGTN]+$",seq)))
  setNames(seq,id)
}
global_alignment <- function(a, b, match_score=2, mismatch=-1, gap=-2) {
  a <- strsplit(a, "")[[1]]; b <- strsplit(b, "")[[1]]
  stopifnot(length(a)>0,length(b)>0,all(a%in%c("A","C","G","T")),
            all(b%in%c("A","C","G","T")))
  n <- length(a); m <- length(b)
  score <- matrix(0,n+1,m+1); step <- matrix(0L,n+1,m+1)
  score[,1] <- (0:n)*gap; score[1,] <- (0:m)*gap
  step[-1,1] <- 2L; step[1,-1] <- 3L
  for(i in 1:n) for(j in 1:m) {
    candidate <- c(score[i,j]+ifelse(a[i]==b[j],match_score,mismatch),
                   score[i,j+1]+gap,score[i+1,j]+gap)
    step[i+1,j+1] <- which.max(candidate)
    score[i+1,j+1] <- max(candidate)
  }
  i <- n; j <- m; aa <- bb <- character()
  while(i>0 || j>0) {
    move <- step[i+1,j+1]
    if(move==1L) { aa<-c(a[i],aa);bb<-c(b[j],bb);i<-i-1;j<-j-1 }
    else if(move==2L) { aa<-c(a[i],aa);bb<-c("-",bb);i<-i-1 }
    else { aa<-c("-",aa);bb<-c(b[j],bb);j<-j-1 }
  }
  list(a=paste(aa,collapse=""),b=paste(bb,collapse=""),score=score[n+1,m+1])
}
