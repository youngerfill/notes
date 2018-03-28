Exercise 1.04
=============

Question:
---------

Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:

.. highlight:: scheme

::

    (define (a-plus-abs-b a b)
        ((if (> b 0) + -) a b))


Answer:
-------

In the body of ``a-plus-abs-b a b``, the expression ``(if (> b 0) + -)`` evaluates to an arithmetic operation (either ``+`` or ``-``, depending on the sign of ``b``'s actual argument). The interpreter obtains a primitive procedure that it applies to the arguments replacing the formal parameters ``a`` and  ``b``.
