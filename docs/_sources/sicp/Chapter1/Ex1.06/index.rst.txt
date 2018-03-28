Exercise 1.06
=============

Background: Section 1.1.7, Square Roots by Newton's Method
----------------------------------------------------------

.. highlight:: scheme

::

    (define (square x) (* x x))

    (define (average x y)
      (/ (+ x y) 2))

    (define (improve guess x)
      (average guess (/ x guess)))

    (define (good-enough? guess x)
      (< (abs (- (square guess) x)) 0.001))

    (define (sqrt-iter guess x)
      (if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

    (define (sqrt x)
      (sqrt-iter 1.0 x))

Question:
---------
Alyssa P. Hacker doesn't see why ``if`` needs to be provided as a special form. "Why can't I just define it as an ordinary procedure in terms of ``cond``?" she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of ``if``:

.. highlight:: scheme

::

    (define (new-if predicate then-clause else-clause)
      (cond (predicate then-clause)
            (else else-clause)))

Eva demonstrates the program for Alyssa:

.. highlight:: scheme

::

    (new-if (= 2 3) 0 5)
    5

    (new-if (= 1 1) 0 5)
    0

Delighted, Alyssa uses new-if to rewrite the square-root program:

.. highlight:: scheme

::

    (define (sqrt-iter guess x)
      (new-if (good-enough? guess x)
              guess
              (sqrt-iter (improve guess x)
                         x)))

What happens when Alyssa attempts to use this to compute square roots? Explain. 

Answer:
-------

The program gets stuck in an infinite loop.

As ``new-if`` is not a special form, both the *consequent* and the *alternative* expression are always evaluated, regardless of the value of the *predicate*. So, in the case of ``sqrt-iter`` the call to ``(sqrt-iter ...)`` in the *consequent* is endlessly recursive, and never finishes.
