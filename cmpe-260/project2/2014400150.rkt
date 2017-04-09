#lang scheme
; compiling: yes
; complete: yes
; 2014400150

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
(define (calc-score held goal)(floor (cond
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
                                 ))
  )

; (find-held-rec steps) -> list?
; steps : list of pairs?
;
; Recursively evaluates reverse order list and returns held cards.
;
;> ( find-held-rec '((discard (H . 3)) (draw (H . A)) (draw (H . 2)) (draw (H . 3))))
;=>((H . 2) (H . A))
(define (find-held-rec steps)(cond
                               ((eqv? (length steps) 0)'())
                               ((eqv? (length steps) 1) (if (equal? (car (car steps)) 'draw) (cdr (car steps)) '()))
                               (else (if
                                      (equal? (car (car steps)) 'draw)
                                         (append (find-held-rec (cdr steps)) (cdr (car steps)))
                                         (remove (car(cdr(car steps))) (find-held-rec (cdr steps)))))
                               )
  )

; (find-held-cards steps) -> list?
; steps : list of pairs?
;
; Sends the reverse list to find-held-rec function.
;
;> ( find-held-cards '((draw (H . 3)) (draw (H . 2)) (draw (H . A)) (discard (H . 3))))
;=>((H . 2) (H . A))
(define (find-held-cards steps)(find-held-rec (reverse steps)))

; (find-held-cards steps) -> list?
; steps : list of pairs?
; table : list of pairs?
; moves : list?
; goal : integer?
;
; Discards one card.
;
;> ( fdiscard '((C . 3) (C . 2) (C . A) (S . J) (S . Q) (H . J)) '(draw draw draw discard) 66
;                '((H . 3) (H . 2) (H . A) (D . A) (D . Q) (D . J)))
;=>((H . 2) (H . A) (D . A) (D . Q) (D . J))
(define (fdiscard table moves goal held)(cdr held))


; (fs-rec  table moves goal held lmoves) -> list?
; table : list of pairs?
; moves : list of pairs?
; goal : list?
; held: list of pairs?
; lmoves: list of pairs?
;
; Recursive function for finding steps. Takes reverse of moves list as argument for recursive purpose(Scheme is tail recursive).
;
;(find-steps '((C . 3) (C . 2) (C . A) (S . J) (S . Q) (H . J)) '(draw discard discard discard discard discard draw draw) 14) 
;=>((draw (C . 3)) (draw (C . 2)) (discard (C . 3)) (discard (C . 2)))
;> (find-steps '((C . 3) (C . 2) (C . A) (S . J) (S . Q) (H . J)) '(discard draw draw) 66) 
;=>((draw (C . 3)) (draw (C . 2)) (discard (C . 3)))

(define (fs-rec table moves goal held lmoves)(if (not(> (calc-playerpoint held) goal))
                                                       (cond
                                                         ((eqv? (length moves) 0) lmoves)
                                                         ((equal? (car moves) 'draw)(if(eqv? (length table) 0) lmoves
                                                                                     (fs-rec (cdr table) (cdr moves) goal (fdraw table held)
                                                                                             (append lmoves (list(list 'draw (car table))))
                                                                                             )
                                                                                     ))
                                                         ((equal? (car moves) 'discard)(if(eqv? (length held) 0) lmoves
                                                                                      (fs-rec table (cdr moves) goal (cdr held)
                                                                                              (append lmoves (list(list 'discard (car held))))
                                                                                              )
                                                                                     ))
                                                         )
                                                       lmoves
                                                       )
  )
; (find-steps table moves goal) -> list?
; table : list of pairs?
; moves : list of pairs?
; goal : list?
;
; Finds steps using recursive sub-function.
;
;(find-steps '((C . 3) (C . 2) (C . A) (S . J) (S . Q) (H . J)) '(draw draw discard discard discard discard discard draw) 14) 
;=>((draw (C . 3)) (draw (C . 2)) (discard (C . 3)) (discard (C . 2)))
;> (find-steps '((C . 3) (C . 2) (C . A) (S . J) (S . Q) (H . J)) '(draw draw discard) 66) 
;=>((draw (C . 3)) (draw (C . 2)) (discard (C . 3)))

(define (find-steps table moves goal)(fs-rec table moves goal '() '()))

; (play table moves goal) -> number?
; table : list of pairs?
; moves : list of pairs?
; goal : list?
;
; Play function for playing the game.
;
;> (play '((H . 4) (H . 5) (H . 6) (H . 7) (H . 8) (H . 9) (D . 2) (D . 3) (D . 4)
;     (D . 5) (D . 6) (D . 7) (D . Q) (D . K) (D . A) (S . 2) (S . 3) (S . Q) (S . K) (S . A)
;     (C . 5) (C . 6) (C . 7) (C . 8) (C . 9) (C . 10) (C . J) (C . Q) (C . K) (C . A))
;    '(draw draw draw draw draw draw draw draw draw draw draw draw draw draw draw draw draw draw
;      draw draw discard discard discard discard discard discard draw draw draw draw) 200) 
;=>80
;>(play '((C . 3) (C . 2) (C . A) (S . J) (S . Q) (H . J)) '(draw draw discard discard discard discard discard draw) 14) 
;=>7

(define (play table moves goal)(floor (calc-score (find-held-cards(find-steps table moves goal)) goal)))

  