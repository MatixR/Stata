program define interaction

    syntax varlist(min=2 max=2 numeric), Generate(name)

    args left right

    local lableft : variable label `left'
    local labright : variable label `right'

    generate `generate' = `left' * `right'
    label variable `generate' "`lableft' \(\times\) `labright'"

    end

