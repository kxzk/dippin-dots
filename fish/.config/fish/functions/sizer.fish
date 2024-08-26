function sizer
    if test (count $argv) -ne 1
        echo "Usage: sizer <filename>"
        return 1
    end

    set filename $argv[1]

    if test -f $filename
        set size_bytes (stat -f %z $filename)
        set size_kb (math "$size_bytes / 1024")
        set size_mb (math "$size_kb / 1024")
        set size_gb (math "$size_mb / 1024")

        echo "$size_bytes B"
        echo "$size_kb KB"
        echo "$size_mb MB"
        echo "$size_gb GB"
    else
        echo "Error: File '$filename' not found or is not a regular file."
        return 1
    end
end
