(module bigloo-support
   (library slib)
   (import helpers)
   (export pretty-print
	   exists
	   remp
	   list-sort
	   add1 sub1
	   for-all
	   new-time
	   div
	   call-with-string-output-port)
   (eval (export-exports)))

(define list-sort sort)
(define pretty-print pp) 
(define div quotient); we're a bit lax here
(define mod remainder); we're a bit lax here
(define call-with-string-output-port call-with-output-string)

;(define exists any)
(define exists
  (lambda (f ls . more)
    (and (not (null? ls))
      (let exists ([x (car ls)] [ls (cdr ls)] [more more])
        (if (null? ls)
            (apply f x (map car more))
            (or (apply f x (map car more))
                (exists (car ls) (cdr ls) (map cdr more))))))))

(define remp filter-out)

(define add1 +1+)
(define sub1 -1+)

(define for-all
  (lambda (f ls . more)
    (or (null? ls)
      (let for-all ([x (car ls)] [ls (cdr ls)] [more more])
        (if (null? ls)
            (apply f x (map car more))
            (and (apply f x (map car more))
                 (for-all (car ls) (cdr ls) (map cdr more))))))))

(define new-time
   (lambda (e)
      (multiple-value-bind (r rt st ut)
	 (time e)
	 (display (format "~nreal:~vuser:~vsys:~v~n"
			  (/fl (exact->inexact rt) 100.0)
			  (/fl (exact->inexact ut) 100.0)
			  (/fl (exact->inexact st) 100.0)))
	 r)))

(define-syntax time
   (syntax-rules ()
      ([_ e ...] (new-time (delay e ...)))
      ))

