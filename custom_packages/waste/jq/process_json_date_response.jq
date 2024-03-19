input? // null |
(if $ARGS.garbage_type == null then "ZAC_GELB" else $ARGS.garbage_type end) as $garbage_type |
(try
    [
        .[]._data[] |
        select(.cal_garbage_type | test($garbage_type, "i"))
    ]
catch null) as $selected |
(try
    [
        $selected[] |
        select(
            (.cal_date | strptime("%Y-%m-%d") | mktime)
            > (now | strftime("%Y-%m-%d") | strptime("%Y-%m-%d") | mktime)
        )
    ]
catch null) as $selected_dates |
(try
    (
        $selected_dates |
        sort_by(
            (.cal_date | strptime("%Y-%m-%d") | mktime)
        )
        | first
    )
catch null) as $response |
(if $garbage_type != null and $response != null and ($response | length) > 0 then "OK" else "Error" end) as $status |
(if $status == "Error" then null else $response end) as $response |
{
    status: $status,
    data: $response
}