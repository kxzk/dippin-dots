function rip
    rg --json -i $argv | delta --syntax-theme OneHalfDark
end
