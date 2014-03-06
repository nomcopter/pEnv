au BufNewFile,BufRead *.gradle setf groovy
au BufReadCmd   *.jar,*.war,*.ear,*.sar,*.rar,*.par        call zip#Browse(expand("<amatch>"))
