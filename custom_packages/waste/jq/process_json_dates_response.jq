input? // null |
(try
    [
        .[]._data[] |
        select(
            (.cal_date | strptime("%Y-%m-%d") | mktime)
            > (now | strftime("%Y-%m-%d") | strptime("%Y-%m-%d") | mktime)
        )
    ]
catch null) as $selected_dates |
(try
    (
        [
            $selected_dates[] |
            .cal_garbage_type 
        ] |
        unique
    )
catch null) as $garbage_types |
(try
    (
        $garbage_types |
        reduce $garbage_types[] as $garbage_type (null;
            .[$garbage_type] += (
                [
                    $selected_dates[] |
                    select(.cal_garbage_type | test("^\($garbage_type)$"; "i"))
                ] |
                sort_by(
                    (.cal_date | strptime("%Y-%m-%d") | mktime)
                ) |
                first
            )
        ) |
        flatten
    ) 
catch null) as $response |
(if $garbage_types != null and $response != null and ($response | length) > 0 then "OK" else "Error" end) as $status |
(if $status == "Error" then null else $response end) as $response |
{
    status: $status,
    data: $response
}