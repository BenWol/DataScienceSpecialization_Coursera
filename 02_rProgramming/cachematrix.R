## Matrix inversion is usually a costly computation and there may be some benefit
## to caching the inverse of a matrix rather than compute it repeatedly. The following
## pair of functions work hand in hand to cache and calculate the inverse of a matrix time efficiently.

## This function creates a special "matrix" object that can cache its inverse.
## Actually it is a list containing a function to
## 1. set the value of the matrix
## 2. get the value of the matrix
## 3. set the value of the inverse
## 4. get the value of the inverse

makeCacheMatrix <- function(x = matrix()) {
      m <- NULL
      set <- function(y) {
            x <<- y
            m <<- NULL
      }
      get <- function() x
      setSolve <- function(solve) m <<- solve
      getSolve <- function() m
      list(set = set, get = get, setSolve = setSolve, getSolve = getSolve)
}


## This next function computes the inverse of the special "matrix" returned by makeCacheMatrix above.
## If the inverse has already been calculated (and the matrix has not changed), it retrieves the inverse
## from the cache and skips the computation. Otherwise, it calculates the inverse of the matrix and sets
## the value of the inverse in the cache via the setmean function.

cacheSolve <- function(x, ...) {
      m <- x$getSolve()
      if(!is.null(m)) {
            message("getting cached data")
            return(m)
      }
      data <- x$get()
      m <- solve(data, ...)
      x$setSolve(m)
      m
}

