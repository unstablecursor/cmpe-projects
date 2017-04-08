#lang scheme
; (card-color card) -> color?
; card : pair?
;
; Determines whether card is red or black
;
; Examples:
; >  ( card-color '(H . A) )
; =>red
; >  ( card-color '(S . 5) )
; =>black
(define (card-color card) (if (or (eqv? (car card) 'D) (eqv? (car card) 'H)) 'red 'black ))
; (card-rank card) -> number?
; card : pair?
;
; Displays the card's number.
;
; Examples:
; >  ( card-rank '(H . A) )
; =>11
; >  ( card-rank '(H . 5) )
; =>5
(define (card-rank card) (cond
                           ((eqv? (cdr card) 'K) 10)
                           ((eqv? (cdr card) 'J) 10)
                           ((eqv? (cdr card) 'Q) 10)
                           ((eqv? (cdr card) 'A) 11)
                           (else (cdr card))
                         )
  )

; (equal-color list) -> boolean?
; card : list of pairs?
;
; Check whether two card is the same color.
;
;> (equal-color '((H . 3) (H . 2)) )
;=>#t
;> (equal-color '((H . 3) (S . 2)))
;=>#f
(define (equal-color list) (if (equal? (card-color (car list)) (card-color (car(cdr list)))) #t #f))

; (all-same-color-rec list) -> color?
; list : list of pairs?
;
; Check whether whole is the same color. If it is return the color, if not return diff
;
;> (all-same-color-rec '((S . 3)(S . 2)(S . A)(C . A)(C . Q)(C . J)) )
;=>black
;> (all-same-color-rec'((H . 3)(H . 2)(H . A)(D . A)(D . Q)(C . J)))
;=>diff
(define (all-same-color-rec list)(cond
                                    ((eqv? (length list) 0) 'red)
                                    ((eqv? (length list) 1) (card-color (car list)))
                                    ((eqv? (length list) 2) (if (equal-color list) (card-color (car list)) 'diff))
                                    ((equal? (card-color (car list)) (all-same-color-rec (cdr list))) (card-color(car list)))
                                    (else 'diff)
                                    )
  )

; (all-same-color list) -> boolean?
; list : list of pairs?
;
; Check whether whole is the same color. Uses all-same-color-rec.
;
;> (all-same-color '((S . 3)(S . 2)(S . A)(C . A)(C . Q)(C . J)) )
;=>#t
;> (all-same-color'((H . 3)(H . 2)(H . A)(D . A)(D . Q)(C . J)))
;=>#f
(define (all-same-color list)(if (equal? (all-same-color-rec list) 'diff) #f #t))

; (fdraw table draw) -> list
; table : list of pairs?
; draw : list of pairs?
;
; Appends the first element of table to draw.
;
;> ( fdraw '((H . 3) (H . 2) (H . A) (D . A) (D . Q) (D . J)) '())
;=>((H . 3))
;>  ( fdraw '((H . 3) (H . 2) (H . A) (D . A) (D . Q) (D . J)) '((S . 3) (S . 2) (S . A)))
;=>((S . 3) (S . 2) (S . A) (H . 3))
(define (fdraw table held) (append held (list (car table))))

; (calc-playerpoint held) -> number?
; held : list of pairs?
;
; Calculates the player point.
;
;> ( calc-playerpoint '((H . A) (H . 3) (D . J) (C . J)) )
;34
;> ( calc-playerpoint '( (H . 3) ))
;3
(define (calc-playerpoint held) (cond
                                  ((eqv? (length held) 0) 0)
                                  ((eqv? (length held) 1) (card-rank (car held)))
                                  (else (+ (card-rank (car held)) (calc-playerpoint (cdr held))))
                                  )
  )
; (calc-score held goal) -> number?
; held : list of pairs?
; goal: integer?
;
; Calculates the final score.
;
;>  (calc-score '((H . 3) (H . 2) (H . A) (D . J) (D . Q) (C . J)) 50 )
;=>4
;> ( calc-score '((H . 3) (H . 2) (H . A) (D . J) (D . Q) (C . J)) 16 )
;=>150
(define (calc-score held goal) (cond
                                 ((all-same-color held)(/ (cond
                                                         ((> (calc-playerpoint held) goal) (* 5 (- (calc-playerpoint held) goal)))
                                                         (else (- goal (calc-playerpoint held)))
                                                       )
                                                     2)
                                                    )
                                 (else (cond
                                                         ((> (calc-playerpoint held) goal) (* 5 (- (calc-playerpoint held) goal)))
                                                         (else (- goal (calc-playerpoint held)))
                                                       )
                                       )
                                 )
  )






(define (find-held-rec steps)(cond
                               ((eqv? (length steps) 1) (if (equal? (car (car steps)) 'draw) (cdr (car steps)) '()))
                               (else (if (equal? (car (car steps)) 'draw) (append (find-held-rec steps) (cdr (car steps))) (cdr steps)))
                               )
  )
(define (find-held-cards steps)(find-held-rec (reverse steps))
  )
;define (fdiscard table moves goal held)(fdiscard-rec )

  