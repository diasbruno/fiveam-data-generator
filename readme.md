# fiveam-data-generator

`fiveam-data-generator` is a random data generation library for Common Lisp.

The library provides generators for primitive types, collections, and composable generator combinators. It is designed to integrate naturally with FiveAM and to support future extensions such as factories and object generation.

This repository is intended to be integrated with the `fiveam`.

## Features

- Primitive generators
- Collection generators
- Generator combinators
- Extensible protocol based on generic functions
- Compatible with FiveAM

## Installation

```lisp
(ql:quickload :fiveam-data-generator)
````

## Usage

Import the package:

```lisp
(use-package :fiveam-data-generator)
```

Generate an integer:

```lisp
(generate
 (gen :integer
	  :min 1
	  :max 10))
```

Generate a string:

```lisp
(generate
 (gen :string
	  :min-length 5
	  :max-length 10))
```

Generate a list:

```lisp
(generate
 (gen :list
	  :of (gen :integer)
	  :min-length 3
	  :max-length 5))
```

Generate a multidimensional array:

```lisp
(generate
 (gen :array
	  :of (gen :double-float)
	  :dimensions '(3 3)))
```

## Combinators

### Constant

```lisp
(generate
 (gen :constant
	  :value 42))
```

### Member

```lisp
(generate
 (gen :member
	  :members '(red green blue)))
```

### One Of

```lisp
(generate
 (gen :one-of
	  :generators
	  (list (gen :integer)
			(gen :string)
			(gen :boolean))))
```

### Map

```lisp
(generate
 (gen :map
	  :generator
	  (gen :integer)
	  :function #'1+))
```

### Filter

```lisp
(generate
 (gen :filter
	  :generator
	  (gen :integer)
	  :predicate #'evenp))
```

### Optional

```lisp
(generate
 (gen :optional
	  :generator
	  (gen :string)))
```

### Tuple

```lisp
(generate
 (gen :tuple
	  :generators
	  (list (gen :string)
			(gen :integer)
			(gen :boolean))))
```

### Bind

```lisp
(generate
 (gen :bind
	  :generator
	  (gen :integer
		   :min 1
		   :max 5)
	  :function
	  (lambda (n)
		(gen :list
			 :of (gen :integer)
			 :min-length n
			 :max-length n))))
```

## Running Tests

```lisp
(asdf:test-system :fiveam-data-generator)
```

## Repository

https://github.com/diasbruno/fiveam-data-generator

## License

This project is released under the Unlicense.
