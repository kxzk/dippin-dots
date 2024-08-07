function extract_transcript
    jq '.results.transcripts[].transcript'
end
