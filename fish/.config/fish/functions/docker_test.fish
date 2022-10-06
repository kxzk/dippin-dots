function _or_check
    return $argv[1]; or $argv[2]
end

function docker_test
    if $uname == "Darwin" && _and_check $argv[1] == "run" $argv[1] == "build"
        echo $argv[1] --platform linux/amd64
    else
        echo $argv
    end
end
