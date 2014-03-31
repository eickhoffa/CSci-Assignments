;;;;CSci 1901 Spring 2012
;;;;HW 5 Scheme TEMPLATE
; =========
;;;;Author:  Adam Eickhoff
;;;;ID #:    4088090
;;;;Lab Section: 5


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem 1 Solution.

;;Takes operation, list, and initial value
;;If list is null, shows initial value, otherwise applies the operation to the car of list and accumulator to the cdr of list
(define (accumulator op lst init) 
  (if (null? lst) init            
      (op (car lst) (accumulator op (cdr lst) init))))
      
      
;;Takes in a list and calls the function that is specified
(define (make-mp-list current-list) 
  (define (dispatch m)            
    (cond ((equal? m 'show) current-list)
	  ((equal? m 'replace) 
	   (lambda (newlist) (set! current-list newlist) current-list))
	  ((equal? m 'accumulate) 
	   (lambda (procedure init) 
	     (accumulator procedure current-list init)))
	  ((equal? m 'map-and-replace) 
	   (lambda (procedure) (map procedure current-list)))))
  dispatch) 


; Generic procedures
(define (show w) (w 'show))
(define (replace w new-list) ((w 'replace) new-list))
(define (accumulate w proc initial) ((w 'accumulate) proc initial))
(define (map-and-replace w proc) ((w 'map-and-replace) proc))

; Test cases 
;;;;Test Case 1 - 'Show;;;;
(newline)(newline)(display "---Test Cases : 1---")
(define w1 (make-mp-list (list "Bach" "Vulpius" "Ravenscroft" "Byrd")))(newline)
(display (show w1))(newline)                                                              ;; should return (Bach Vulpius Ravenscroft Byrd)
(define w2 (make-mp-list (list 1 2 3 4 5)))
(display (show w2))(newline)                                                              ;; should return (1 2 3 4 5)
(define w3 (make-mp-list (list "Eickhoff" "Booth" "Shallenberger" "Meyer")))
(display (show w3))(newline)                                                              ;; should return (Eickhoff Booth Shallenberger Meyer)
(define w4 (make-mp-list (list 10 9 8 7 6)))
(display (show w4))(newline)                                                              ;; should return (10 9 8 7 6)
(define w5 (make-mp-list (list "CSCI" "MATH" "ARCH" "HSCI")))
(display (show w5))(newline)                                                              ;; should return (CSCI MATH ARCH HSCI)



;;;;Test Case 2 - 'Replace;;;;
(newline)(display "---Test Cases : 2---")(newline)
(display (replace w1 (list "Tallis" "Vulpius" "Anonymous" "Byrd" "Palestrina")))(newline) ;; should return (Tallis Vulpius Anonymous Byrd Palestrina)
(display (replace w2 (list 6 7 8 9 10)))(newline)                                         ;; should return (6 7 8 9 10)
(display (replace w3 (list "Hanninen" "Will" "Pan" "Hammann")))(newline)                  ;; should return (Hanninen Will Pan Hammann)
(display (replace w4 (list 20 18 16 14 12)))(newline)                                     ;; should return (20 18 16 14 12)
(display (replace w5 (list "Majors" "Classes" "University")))(newline)                    ;; should return (Majors Classes University) 



;;;;Test Case 3 - 'Accumulate;;;;
(newline)(display "---Test Cases : 3---")(newline)
(display (accumulate w2 + 0))(newline)                                                           ;;should return 40
(display (accumulate w4 * 10))(newline)                                                          ;;should return 9676800
(display (accumulate (make-mp-list (list 10 20 30 40 50 60 70 80 90 100)) + 500))(newline)       ;;should return 1050
(display (accumulate (make-mp-list (list 9 8 1 5 10 49 1 30)) - 1000))(newline)                  ;;should return 929
(display (accumulate (make-mp-list (list 1 203 29 30 1883 293)) + 15))(newline)                  ;;should return 2454




;;;;Test Case 4 - 'Map-and-Replace;;;;
(newline)(display "---Test Cases : 4---")(newline)
(display (map-and-replace w2 square))(newline)                                                        ;;should return (36 49 64 81 100)
(display (map-and-replace w4 square))(newline)                                                        ;;should return (400 324 256 196 144)
(display (map-and-replace (make-mp-list (list 10 20 30 40 50 60 70 80 90 100)) square))(newline)      ;;should return (100 400 900 1600 2500 3600 4900 6400 8100 10000)
(display (map-and-replace (make-mp-list (list 9 8 1 5 10 49 1 30)) sqrt))(newline)                    ;;should return (3 2.8284271247461903 1 2.23606797749979 3.1622776601683795 7 1 5.477225575051661)
(display (map-and-replace (make-mp-list (list 1 203 29 30 1883 293)) square))(newline)                ;;should return (1 41209 841 900 3545689 85849)







