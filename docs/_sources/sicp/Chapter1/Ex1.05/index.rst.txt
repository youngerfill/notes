Exercise 1.05
=============

Question:
---------

Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:

.. highlight:: scheme

::

    (define (p) (p))

    (define (test x y)
      (if (= x 0)
          0
          y))


Then he evaluates the expression

.. highlight:: scheme

::

    (test 0 (p))


What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form ``if`` is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)


Answer:
-------

Applicative-order evaluation:
.............................

The program gets stuck in an infinite loop.

When the program evaluates the second operand in the call ``(test 0 (p))`` it will substitute ``(p)`` with its definition. As this definition is also ``(p)``, the substitution process is endlessly recursive.


Normal-order evaluation:
.............................

The program returns ``0``.

When ``(test 0 (p))`` is called, its operands are not evaluated immediately. Instead, the procedure ``test`` is expanded to:

::

      (if (= 0 0)
          0
          (p)))

The *predicate* in the special form ``if`` evaluates to ``true``, so the *alternative* ``(p)`` is never evaluated and the *consequent*'s value ``0`` is returned.
