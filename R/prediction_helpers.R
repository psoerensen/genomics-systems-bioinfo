# Restricted teaching ridge model: standardized features, separate intercept.
# Objective: SSE + lambda * sum(beta^2), after optional block weights.
fit_teaching_ridge <- function(X, y, lambda=4, weights=rep(1,ncol(X))) {
  stopifnot(is.matrix(X),nrow(X)==length(y),nrow(X)>2,ncol(X)>0,
            !is.null(colnames(X)),!anyDuplicated(colnames(X)),
            all(is.finite(X)),all(is.finite(y)),lambda>0,
            length(weights)==ncol(X),all(is.finite(weights)),all(weights>0))
  center <- colMeans(X); spread <- apply(X,2,sd)
  stopifnot(all(spread>0))
  Z <- sweep(scale(X,center,spread),2,weights,"*")
  intercept <- mean(y)
  beta <- solve(crossprod(Z)+lambda*diag(ncol(Z)),crossprod(Z,y-intercept))
  list(center=center,spread=spread,weights=weights,beta=beta,intercept=intercept)
}
predict_teaching_ridge <- function(model,X) {
  stopifnot(is.matrix(X),!anyDuplicated(colnames(X)),
            setequal(colnames(X),names(model$center)),all(is.finite(X)))
  X <- X[,names(model$center),drop=FALSE]
  Z <- sweep(scale(X,model$center,model$spread),2,model$weights,"*")
  as.vector(model$intercept+Z%*%model$beta)
}
