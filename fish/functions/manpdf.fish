function manpdf
    man -t $argv[1] | open -f -a Preview
end
