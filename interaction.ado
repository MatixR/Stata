program define interaction

    syntax varlist(min=2 max=2 numeric), Generate(name)

    tokenize `varlist'

    local lab1 : variable label `1'
    local lab2 : variable label `2'

    generate `generate' = `1' * `2'

    label variable `generate' "`lab1' \(\times\) `lab2'"
    notes `generate' : "interaction of variables `1' and `2'"

    end

