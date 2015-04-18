#lang racket
(require racket/include)

(include (file "atom.rkt"))

; TOYS {{{

; Atoms {{{

(atom? 'atom)
; #t/yes because it is a string of characters beginning with the letter
; a 

(atom? 'turkey)
; Yes, because turkey is a string of characters beginning with a letter

(atom? '1492)
; Yes, because it is a string of digits.

(atom? 'u)
; Yes, because it is a string of one character, which is a letter.

(atom? '*abc$)
; Yes, because: 
; - it is string of characters 
; - begins with a character that is not '(' or ')'

; }}} Atoms

; Lists {{{

(list? '(atom))
; Yes, it is an atom enclosed in parentheses. This makes a list

(list? '(atom turkey or))
; Yes, it is set/collection of atoms encloses in parentheses.

(list? "(atom turkey) or")
; Not a list. It is a list followed by an atom/s-expression

(list? '((atom turkey) or))
; Yes, it is a list and an atom in a list. Two s-expressions encloses in
; parentheses

(length '(how are you doing so far))
; 6 s-expressions in the list

(length '(((how) are) ((you) (doing so)) far) )
; 3, it is a collection of s-expression enclosed by parentheses

(list? '())
; Yes, it's an empty list

(list? '( () () () () ) )
; Yes, it's a list of empty lists

; }}} Lists

; The Law of Car
; The primitive car is defined only for non-empty lists.

; car {{{
(car '(a b c))
; a because it is the first s-expression in the list

(car '((a b c) x y z))
; (a b c) because it is the first s-expression

;(car 'hotdog)
; No. You cannot ask for car of an atom. car only operates on lists.

;(car '()) 
; No. You cannot ask for car on an empty list.

(define l '(((hotdogs)) (and) (pickle) relish))
(car l)
;((hotdogs))

(car (car l))
; (hotdogs)

; }}} car

; Law of Cdr
; The primitive cdr is defined only for non-empty lists.
; The cdr of any non-empty list is always another list

; {{{ cdr 

(cdr '(a b c))
; (b c) - cdr is the list (a b c) without car (a b c)
; (b c) - cdr gives the list sans the first expression.
; cdr gives the body (and tail); it does not give the head

(set! l '((a b c) x y z))
(cdr l)
;(x y z)

(set! l '(hamburger))
(cdr l)

; () - empty. there was only one s-expression. l without car l is an
; empty list in this case

;(cdr 'hotdogs)
; No - You cannot ask for cdr on an atom.

;(cdr '())
; No - You cannot ask for cdr on the null/empty list

(set! l '((b) (x y) ((c))))
(car (cdr l))
;(x, y). (cdr l) gives ((x y) ((c)))
; (car ((x y) ((c)))) gives ()


(set! l '((b) (x y) ((c))))
(cdr (cdr l))
; (((c)))

; }}}

; The Law of Cons
; The primitive cons takes two arguments.
; The second argument must be a list. The result is a list.

; {{{ cons 
(set! l '(butter and jelly))
(define a 'peanut)
(cons a l)
; (peanut butter and jelly) - cons prepends an s-expression to the
; beginning of a list

(cons '(banana and) '(peanut butter and jelly))
;( (banana and) peanut butter and jelly)

(cons 'a (car '((b) c d)))
;(a b) - car gives (b), cons a (b) gives (a b) 


; }}}

; The Law of Null
; The primitive null? is defined only for lists
; {{{ null?
(null? '()) ; true, () is the null list
(null? '(a b c)) ; false, (a b c) is not an empty list
(null? 'a) ; false, a is an atom
; }}}


; The Law of Eq?
; The primitive eq? takes two arguments. Each must be a non-numeric atom
; {{{ eq?
(eq? 'Harry 'Harry) ; true, Harry and Harry are the same atom
(eq? 'margarine 'butter) ; false, margarine is not the same atom as butter
;
; }}}

; }}} TOYS

; Where did these strange names come from?
; https://en.wikipedia.org/wiki/CAR_and_CDR
; 
; car and cdr also go by alternate names, first/head and rest/tail, respectively.

