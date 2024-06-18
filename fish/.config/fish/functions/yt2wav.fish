function yt2wav
    # Check if URL is provided
    if not set -q argv[1]
        echo "usage: youtube_to_wav <youtube url>"
        exit 1
    end

    # YouTube Video URL
    set URL $argv[1]

    # Download the best audio quality using yt-dlp and convert to WAV using FFmpeg
    yt-dlp -x --audio-format wav --audio-quality 0 -o "%(title)s.%(ext)s" "$URL"
end
