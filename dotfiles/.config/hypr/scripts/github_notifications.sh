#! /usr/bin/env bash
#
# Copyright (c) 2024 Marko Sagadin. All Rights Reserved.
#
# Pooling-style script for fetching notifications from the GitHub and
# publishing them as true Linux notifications with notify-send utility.
# Notifications contain basic info, such as what event happened, to
# which repo it belongs. Whenever possible, the notifications will also
# have a clickable button that will open the related issue/PR in the default
# browser.
#
# Both public GitHub instances and enterprise GitHub instances are supported.
#
# Script needs to be called regularly for it to work. It is up to the user to
# decide how often they want to call it and how they want to do that.
#
# SETUP
#
# 1. install jq and gh:
#
#   sudo apt install jq gh
#
# 2. Login to all GitHub accounts that you want to receive notifications for:
#
#   gh auth login
#
# 3. Create ~/github_hostnames.sh file that exports variable GITHUB_HOSTNAMES.
#
#   1. Example, listen only on github.com
#
#       export GITHUB_HOSTNAMES=("github.com")
#
#   2. Example, listen on github.com and big.corp.org
#
#       export GITHUB_HOSTNAMES=("github.com" "big.corp.org")
#
# 4. Call the script regularly. You can use cron or some other mechanism.
#
#   For example, to call this script every minute with cron:
#
#       1. Open crontab file: crontab -e
#       2. Add the following line and save:
#
#           * * * * * bash <path to this script>

# This is required to get notify-send working if the script is run from cron.
export XDG_RUNTIME_DIR=/run/user/$(id -u)

source ~/github_hostnames.sh

# If set to true, then the below debug_mode_* files are used as inputs, instead
# of using the exact API.
DEBUG_MODE=0
debug_mode_old_noti_file="first_list.json"
debug_mode_current_noti_file="second_list.json"

get_notifications_from_hostname() {
    local hostname=$1

    res=$(gh api notifications --hostname ${hostname})

    fields="{\
        id: .id, \
        reason: .reason, \
        url: .subject.url, \
        title: .subject.title, \
        latest_comment_url: .subject.latest_comment_url, \
        repo: .repository.name, \
        type: .subject.type, \
        org: .repository.owner.login \
    }"

    # 1. Filter all unread notifications from the results.
    # 2. Extracts fields of interest.
    # 3. Use slurp mode -s to create an array of objects.
    echo "$res" |
        jq ".[] | select(.unread==true) | ${fields}" |
        jq -s '.'
}

get_new_notifications() {
    local first_list=$1
    local second_list=$2
    # Extract all "id" values from the first list (first_list.json)
    old_ids=$(echo $first_list | jq 'map(.id) | .[]')

    # Pack all ids into an array with slurp mode.
    old_ids=$(echo "$old_ids" | jq -s '.')

    # 1. use argjson to get access to the variable in the main query
    # 2. For every object in array:
    #   - save value of .id into variable $id.
    #   - pass the list of $old ids into index
    #   - index($id) operates on the $old_ids list, it returns index of the first
    #   matching id value. If it doesn't find it it return none.
    #   - So the first part works as a union filter
    #   - the not inverts that
    # 3. The result is a list of object that are only present in the second list,
    # but not in first.
    echo $second_list | jq --argjson old_ids "$old_ids" \
        'map(select(.id as $id | $old_ids | index($id) | not))'
}

pretiffy_reason() {
    local reason=$1
    case $reason in
    "assign")
        echo "You were assigned"
        ;;
    "author")
        echo "You created it"
        ;;
    "comment")
        echo "Comment was made"
        ;;
    "invitation")
        echo "You got an invite"
        ;;
    "manual")
        echo "You subscribed"
        ;;
    "mention")
        echo "You were mentioned"
        ;;
    "review_requested")
        echo "Review was requested"
        ;;
    "security_alert")
        echo "Security alert for a repo"
        ;;
    "state_change")
        echo "Thread status changed"
        ;;
    "subscribed")
        echo "New notification"
        ;;
    "team_mention")
        echo "Your team was mentioned"
        ;;
    "ci_activity")
        echo "CI"
        ;;
    *)
        echo "Unknown reason: $reason"
        ;;
    esac
}

get_link() {
    local url=$1
    local latest_comment_url=$2

    if [[ "$latest_comment_url" != null && "$url" != null ]]; then
        # If we have both links that means that we can construct exact comment
        # link. And this works for both issues and pulls, regardless of the
        # weird below name.
        comment_id=$(echo $latest_comment_url | rev | cut -d'/' -f 1 | rev)
        echo "${url}#issuecomment-${comment_id}"
    elif [[ "$latest_comment_url" != null ]]; then
        # Prefer latest comment link as a second best option
        echo "$latest_comment_url"
    elif [[ "$url" != null ]]; then
        echo "$url"
    else
        echo ""
    fi

}

determine_type() {
    local type=$1

    if [[ "$type" = "PullRequest" ]]; then
        echo "PR"
    elif [[ "$type" = "Issue" ]]; then
        echo "Issue"
    else
        echo ""
    fi
}

get_hash_number() {
    local link=$1

    if [[ -z $link ]]; then
        echo ""
    else
        maybe_number=$(echo $link | rev | cut -d'/' -f 1 | rev)
        re='^[0-9]+$'
        if [[ "$maybe_number" =~ $re ]]; then
            echo "$maybe_number"
        else
            echo ""
        fi
    fi
}

construct_msg() {
    local org=$1
    local repo=$2
    local title=$3
    local type=$4

    local msg="\n<b>Owner</b>: ${org}\n<b>Repo</b>: ${repo}\n"

    if [[ ! -z $type ]]; then
        msg+="<b>${type}</b>: ${title}"
    else
        msg+="<b>Message</b>: ${title}"
    fi

    echo "$msg"

}

construct_button_label() {
    local type=$1
    local hash_number=$2

    if [[ (! -z $type) && (! -z $hash_number) ]]; then
        echo "Open $type #$hash_number"
    else
        echo ""
    fi
}

send_notify() {
    local reason=$1
    local msg=$2
    local label=$3
    local url=$4

    if [[ ! -z $label ]]; then
        opt=$(notify-send --action="opt1=$label" "$reason" "$msg")
        # Check if the notification was clicked
        if [[ ! -z $opt ]]; then
            xdg-open $link
        fi
    else
        notify-send "$reason" "$msg"
    fi

}

cleanup_link() {
    # Cleanup non-functioning links, there also a slight difference in the links
    # coming from the GitHub.com and enterprise versions.
    echo $1 |
        sed 's|//api.|//|g' |
        sed 's|/api/v3/|/|g' |
        sed 's|/repos/|/|g' |
        sed 's|/pulls/|/pull/|g'
}

# Make sure that .cache folder exists, before writing any while there.
mkdir -p ~/.cache

for hostname in ${GITHUB_HOSTNAMES[@]}; do

    current_noti_list=$(get_notifications_from_hostname "$hostname")
    old_noti_file=~/.cache/github_notifications_${hostname}.txt

    # If there is no saved file, just save notifications
    if [[ $DEBUG_MODE -eq 1 ]]; then
        current_noti_list=$(<$debug_mode_current_noti_file)
        old_noti_list=$(<$debug_mode_old_noti_file)
    else

        if [[ ! -f $old_noti_file ]]; then
            echo $current_noti_list >$old_noti_file
            continue
        fi

        old_noti_list=$(<$old_noti_file)
        echo $current_noti_list >$old_noti_file
    fi

    new_noti_list=$(get_new_notifications "$old_noti_list" "$current_noti_list")

    # Pass the list into the jq that will then pass line by line to the read.
    echo "$new_noti_list" | jq -c '.[]' | while read noti; do

        # -r/--raw-output flag removes double quotes
        reason=$(echo "$noti" | jq -r '.reason') title=$(echo "$noti" | jq -r '.title')
        url=$(echo "$noti" | jq -r '.url')
        repo=$(echo "$noti" | jq -r '.repo')
        org=$(echo "$noti" | jq -r '.org')
        type=$(echo "$noti" | jq -r '.type')
        latest_comment_url=$(echo "$noti" | jq -r '.latest_comment_url')

        url=$(cleanup_link "$url")
        latest_comment_url=$(cleanup_link "$latest_comment_url")
        link=$(get_link $url "$latest_comment_url")
        type=$(determine_type "$type")
        reason=$(pretiffy_reason "$reason")
        hash_number=$(get_hash_number "$url")

        msg=$(construct_msg "$org" "$repo" "$title" "$type")

        label=$(construct_button_label "$type" "$hash_number")

        (send_notify "$reason" "$msg" "$label" "$url") &

    done

done
