## Pipe this after cat to extended-regexp-grep for email address in a file

grep -Eio '([[:alnum:]_.-]+@[[:alnum:]_.-]+?.[[:alpha:].]{2,6})'
