#!/usr/bin/env fish

function random_name
    set -l dune_characters \
        PaulAtreides \
        LetoAtreides \
        LadyJessica \
        DuncanIdaho \
        GurneyHalleck \
        ThufirHawat \
        VladimirHarkonnen \
        FeydRautha \
        PiterDeVries \
        Stilgar \
        Chani \
        LietKynes \
        Jamis \
        Reverend_Mother_Mohiam \
        CountFenring \
        LadyMargot \
        Shaddam_IV \
        PrincessIrulan \
        Rabban \
        Yueh
    set -l random_index (random 1 (count $dune_characters))
    echo $dune_characters[$random_index]
end

function random_ticket_number
    set -l tick_num (random 9000000000 9999999999)
    echo "$tick_num"
end

set fullname (random_name)
set ticket_number (random_ticket_number)

curl -s "https://haabproject.com/thank-you-cafe-wifi/?fullname=$fullname&email=nebaronharko@gmail.com&ticketnumber=$ticket_number" -o response.html

echo "[wifi code]: " (grep "Wifi Code:" response.html | sed 's/.*Wifi Code: \([0-9]*\).*/\1/')

rm response.html
