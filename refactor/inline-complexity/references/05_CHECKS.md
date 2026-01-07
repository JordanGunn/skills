# Checks

## 1. Nested Calls in Arguments (Strong)

Flag:

```python
f(g(x), h(y))
```

Recommend:

```python
gx = g(x)
hy = h(y)
f(gx, hy)
```

## 2. Deep Attribute Access (Strong)

Flag chains >2 levels when used inline.

Recommend staged access with named variables.

## 3. Compound Expressions (Suggestion → Strong)

Flag:

- inline math
- multi-part boolean conditions

Recommend stepwise extraction.
