while read p; do
      racket -f 2014400150.rkt -e "$p"
  done <tests.txt
