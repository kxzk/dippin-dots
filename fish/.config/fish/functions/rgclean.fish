function rgclean
    sed 's/  */ /g' | tr '[:upper:]' '[:lower:]'
end
