function issue_branch
    # create issue
    set -l issue (jira issue create -tStory -s"$argv" --custom team=23 --no-input)

    # get issue number
    set -l issue_number (string split -r -m1 -f2 / "$issue")

    # assign issue to myself
    jira issue assign $issue_number (jira me)

    # create branch w/ issue number
    set -l issue_br_fmt (echo "$argv" | string lower | string replace -a ' ' '-')
    git checkout -b (eval echo "$issue_number-$issue_br_fmt")
end
