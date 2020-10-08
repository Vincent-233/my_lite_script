#!/bin/bash
for f in $(ls 123*) 
do
    line_count=$(wc $f -l|awk '{print $1}')
    if ((line_count > 3)) 
    then
        echo $f >> good.txt
    fi
done

## refer: https://linuxhint.com/bash_command_output_variable/
## refer: https://www.cyberciti.biz/faq/bash-for-loop/
## refer: https://learning.oreilly.com/library/view/bash-quick-start/9781789538830/98fd5a46-2248-462c-b339-34c6bbaebe62.xhtml