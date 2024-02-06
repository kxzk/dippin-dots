function get_tail
    # Check if 'tailwindcss' exists in the current directory
    if test -f tailwindcss
        rm tailwindcss
    end

    # Download the latest tailwindcss binary for macOS arm64
    curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-arm64

    # Make the binary executable
    chmod +x tailwindcss-macos-arm64

    # Move and rename the binary to 'tailwindcss'
    mv tailwindcss-macos-arm64 tailwindcss
end

