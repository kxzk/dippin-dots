function rip
    rg --json -i $argv | delta --syntax-theme Dracula
end
