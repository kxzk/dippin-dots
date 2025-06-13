function colors --description "Display terminal color capabilities"
    # basic colors
    echo
    echo "=== Basic Colors ==="
    echo -e "\033[0;30mBlack\033[0m"
    echo -e "\033[0;31mRed\033[0m"
    echo -e "\033[0;32mGreen\033[0m"
    echo -e "\033[0;33mYellow\033[0m"
    echo -e "\033[0;34mBlue\033[0m"
    echo -e "\033[0;35mMagenta\033[0m"
    echo -e "\033[0;36mCyan\033[0m"
    echo -e "\033[0;37mWhite\033[0m"

    # bright colors
    echo
    echo "=== Bright Colors ==="
    echo -e "\033[0;90mBright Black (Gray)\033[0m"
    echo -e "\033[0;91mBright Red\033[0m"
    echo -e "\033[0;92mBright Green\033[0m"
    echo -e "\033[0;93mBright Yellow\033[0m"
    echo -e "\033[0;94mBright Blue\033[0m"
    echo -e "\033[0;95mBright Magenta\033[0m"
    echo -e "\033[0;96mBright Cyan\033[0m"
    echo -e "\033[0;97mBright White\033[0m"

    # background colors
    echo
    echo "=== Background Colors ==="
    echo -e "\033[40m\033[1;37mBlack Background\033[0m"
    echo -e "\033[41mRed Background\033[0m"
    echo -e "\033[42mGreen Background\033[0m"
    echo -e "\033[43mYellow Background\033[0m"
    echo -e "\033[44mBlue Background\033[0m"
    echo -e "\033[45mMagenta Background\033[0m"
    echo -e "\033[46mCyan Background\033[0m"
    echo -e "\033[47mWhite Background\033[0m"

    # text styles
    echo
    echo "=== Text Styles ==="
    echo -e "\033[1mBold\033[0m"
    echo -e "\033[2mDim\033[0m"
    echo -e "\033[3mItalic\033[0m"
    echo -e "\033[4mUnderline\033[0m"
    echo -e "\033[5mBlink\033[0m"
    echo -e "\033[7mReverse\033[0m"
    echo -e "\033[8mHidden\033[0m (Hidden text)"
    echo -e "\033[9mStrikethrough\033[0m"

    # 256 color palette
    echo
    echo "=== 256 Color Palette ==="
    for i in (seq 0 15)
        for j in (seq 0 15)
            set code (math "$i * 16 + $j")
            printf "\033[38;5;%dm%3d\033[0m " $code $code
        end
        echo
    end

    echo
    echo "=== True Color (24-bit RGB) Examples ==="
    echo -e "\033[38;2;255;0;0mRed (255,0,0)\033[0m"
    echo -e "\033[38;2;0;255;0mGreen (0,255,0)\033[0m"
    echo -e "\033[38;2;0;0;255mBlue (0,0,255)\033[0m"
    echo -e "\033[38;2;255;165;0mOrange (255,165,0)\033[0m"
    echo -e "\033[38;2;128;0;128mPurple (128,0,128)\033[0m"
end

