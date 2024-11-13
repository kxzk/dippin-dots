#!/usr/bin/env fish

function p2
    # Get the number of powers to print (default to 10 if not provided)
    set -l max_power $argv[1]
    if test -z "$max_power"
        set max_power 10
    end

    # Validate input
    if not string match -qr '^[0-9]+$' $max_power
        echo "Error: Please provide a valid positive number"
        return 1
    end

    # Calculate and print each power of 2
    for i in (seq 0 $max_power)
        set -l result (math "2^$i")
        printf "2^%d = %d\n" $i $result
    end
end
