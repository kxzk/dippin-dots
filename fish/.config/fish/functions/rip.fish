function rip
    rg --json -i $argv | delta --syntax-theme gruvbox-dark
end
