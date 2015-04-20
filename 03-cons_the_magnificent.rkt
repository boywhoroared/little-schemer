#lang racket
(require racket/include)

; {{{ REMBER

; rember takes an atom and a list of atoms. It removes the first occurrence of
; atom from the list of atoms.
; That is, it makes a new list of atoms with the first occurrence of atom removed.

(define rember
        (lambda (a lat)
          (cond
            ((null? lat) (quote ()))
            (else (cond
                    ((eq? a (car lat)) (cdr lat))
                    (else (rember a (cdr lat))))))))

; How does this keep the previous list items?
; When it finishes recurring, it just returns (cdr lat)?!
(rember 'bacon '(bacon lettuce and tomato))
; correct: (lettuce and tomato)

(rember 'and '(bacon lettuce and tomato))
; incorrect: (tomato) != (bacon lettuce tomato)

; Oh. Yes. It needs 'cons'. Cons the Magnificent.
; Rule #2 Always build lists with cons!

(set! rember
  (lambda (a lat)
    (cond
      ((null? lat) (quote ()))
      (else (cond
              ((eq? (car lat) a) (cdr lat))
              (else (cons (car lat)
                          (rember a (cdr lat)))))))))

(rember 'and '(bacon lettuce and tomato))

; ask null? lat, no; go to next question
; ask else, yes
; ask eq? bacon and, no
; ask else, yes
; answer (cons bacon (rember and (lettuce and tomato)))
;   (rember and (lettuce and tomato))
;   ask null? (lettuce and tomato) no
;   ask else, yes
;   ask eq? lettuce and, no
;   ask else, yes
;   answer (cons lettuce (rember and (and tomato)))
;     ask null? (and tomato), no
;     ask else, yes
;     ask eq? and and, yes!
;     answer (cdr lat) -> answer tomato
;   answer (cons lettuce (tomato)) -> (lettuce tomato)
; answer (cons bacon (lettuce tomato))
; (bacon lettuce tomato)

; We check the lat one atom at a time. If the current atom does not match
; 'a', we save it, and try to find 'a' in the remaining atoms.
; When we  find 'a', we join the previous atoms to the remaining atoms.

; Simplify
(set! rember
  (lambda (a lat)
    (cond
      ((null? lat) (quote ()))
      ((eq? (car lat) a) (cdr lat))
      (else (cons (car lat) (rember a (cdr lat))))
    )
  )
)

(rember 'sauce '(soy sauce and tomato sauce))

; }}}

; {{{ FIRSTS

; first accepts a list, which may be empty or composed of lists. It produces
; a list composed of the first expression from each list

; commandments ask null
;

; my attempt
(define firsts
  (lambda (l)
    (cond
      ((null? l) (quote ()))
      (else (cons (car (car l)) (firsts (cdr l))))
    )
  )
)

(firsts '((a b c d) (b c d e) (c d e f) (d e f g)))
;(a b c d)
(firsts '((a b c d) (b) (c d e f) (d e f g)))
;(a b c d)
(firsts '(((a b) c d) (b) (c d e f) (d e f g)))
;((a b) b c d)

; YES. Correct

; }}}

; THE THIRD COMMANDMENT
; When building a list, describe the typical first element, and then it cons
; it onto the natural recursion.

; {{{ INSERTR

; my attempt.

; The base case would be:
; given  new => 'c', old => 'b', lat => '(a b d e)'
;
; (cons (a b) (cons c (d e)))
; -> (cons (cons a (car (b d e))) (cdr (b d e)))
; Presume we found old -- (eq? (car lat) old) -- and we have some previous list of s-expressions,
; Cons the previous list to old/(car lat).
; Cons this new list to the cdr(lat)

(define insertR
  (lambda (n o lat) ; new seems to be a reserved word in racket
    (cond
      ((null? lat) (quote ()))
      ; If we have found old, insert `new` to the right of `old`
      ((eq? o (car lat)) (cons o (cons n (cdr lat))))
      ; Keep the current item; Search for 'old' in the remainder of the list.
      (else (cons (car lat) (insertR n o (cdr lat))))
    )
  )
)

(insertR 'topping 'fudge '(ice cream with fudge for dessert))

; Try insertL

(define insertL
  (lambda (n o lat) ; new seems to be a reserved word in racket
    (cond
      ((null? lat) (quote ()))
      ; If we have found old, insert `new` to the left of `old`
      ((eq? o (car lat)) (cons n lat))

      ; NOTE: (cons new (cons old (cdr lat))) is (cons new lat)
      ; I saw it before the book pointed it out. w00t.

      ; Keep the current item; Search for 'old' in the remainder of the list.
      (else (cons (car lat) (insertL n o (cdr lat))))
    )
  )
)

(insertL 'topping 'fudge '(ice cream with fudge for dessert))

; }}}
