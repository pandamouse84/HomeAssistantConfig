input? // null |
(try . catch null) as $raw |
(if $raw[0].uuid != null then $raw else null end) as $response |
(if $raw != null and $response != null and ($response | length) > 0 then "OK" else "Error" end) as $status |
{
    status: $status,
    data: $response
}