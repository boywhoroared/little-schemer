#lang racket
(require racket/include)

(include (file "atom.rkt"))

; {{{ add1
(define add1 
  (lambda (n)
    (+ n 1)))

(add1 67);

; }}}

; {{{ sub1
(define sub1
  (lambda (n)
    (- n 1))) 

(sub1 5)
; }}}

; {{{ o+
(define o+ 
  (lambda (n m)
    (cond
      ((zero? m) n)
      (else (add1 (o+ n (sub1 m)))))))
      ; At first I used :
      ; (else (o+ (add1 n) (sub1 m))))))
      ; Which is not as good because I am changing both arguments, rather than
      ; one? Occams' Razor?

(o+ 46 12)
; }}}

; {{{ o-
(define o- 
  (lambda (n m)
    (cond 
      ((zero? m) n)
      (else (sub1 (o- n (sub1 m)))))))

(o- 14 3) 
(o- 17 9)

; o- takes two arguments. It reduces the second argument to 0. It subtracts one
; from the first argument as many times as it did to cause the second to reach 0.
;
; o- takes two arguments. For every one time it decrements the second, it 
; decrements the first, until the second has reached 0.
; }}}
