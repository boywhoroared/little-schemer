#lang racket
(require racket/include)

(include (file "atom.rkt"))

; {{{ lat?
(define lat?
  (lambda (l)
    (cond 
;     ; Is l a null list? Return true, if it is
      [(null? l) #t]
;     ; Is the first item of the list an atom?
;     ; If it is, we ask lat? on the rest of the list (lat? cdr(l))
;     ;
;     ; That is, if this item is a atom, we will ask if the rest of the
;     ; list is composed of atoms.
      [(atom? (car l)) (lat? (cdr l))]
;     ; If it isn't a list or atom, return false.
      [else #f]
    )
  )
)
; a lat is a list of atoms


; (cond ...) asks a series of questions.
; If the answer is true, it stops and gives an answer
; If the answer is false, it moves on to the next question
; else specifies the answer if none of the questions were answered true.

(lat? '())
(lat? '(bacon and eggs))
; #t
; lat? '(bacon and eggs) - l is a list, (car l) is 'bacon, an atom, ask (lat? (cdr l))
; -> lat? '(and eggs) - l is a list, (car l) is 'and, an atom, ask (lat? (cdr l))
; -> lat? '(eggs) - l is a list, (car l) is 'eggs, an atom, ask (lat? (cdr l))
; -> lat? '() - l is the null list, return true (no atoms to check!)
; -> #t

; Ah, now the title of this chapter makes sense.
; "Do it, Do it again, and again, and again" is Recursion!

(lat? '(bacon (and eggs)))
; #f

; }}}

; {{{ OR
; or asks two questions, one at a time.
; If the first one is true, it stops and answers true.
; Otherwise, it asks the second question and answers
; with whatever the second question answers.
(or (null? '()) (atom? '(d e f g))) ; true for the first question null? '()
(or (null? '(a b c)) (null? '())) ; true for the second question null? '()
(or (null? '(a b c)) (null? '(atom))) ;false - neither of the questions have true answers

; }}}


; {{{ MEMBER
(define member?
  (lambda (a lat)
    (cond
      ; Ask the first question. If we have an empty list, stop. If we do not,
      ; ask the next question.
      ((null? lat) #f) 
      ; Ask the second question. Is a equal to the first s-expression in the 
      ; list? Or is it -- we recur -- is a member of the rest of the list? 
      (else (or 
          (eq? a (car lat))
          (member? a (cdr lat))
        )
      )
    )   
  )  
)

(member? 'meat '(mashed potatoes and meat gravy))
(member? 'liver '(bagles and lox))

; }}}

