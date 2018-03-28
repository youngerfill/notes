Exercise 1.03
=============

Question:
---------

Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers. 


Answer:
-------

.. highlight:: scheme

::

    (define (square x) (* x x))

    (define (sum-of-squares x y) (+ (square x) (square y)))

    (define (sum-squares-larger a b c)
        (cond ((and (<= a b) (<= a c)) (sum-of-squares b c))
              ((and (<= b a) (<= b c)) (sum-of-squares a c))
              (else (sum-of-squares a b))))
