input? // null |
(try . catch null) as $raw |
(if $raw.currentMeasurement.value != null then $raw else null end) as $response |
(if $raw != null and $response != null then "OK" else "Error" end) as $status |
{
    status: $status,
    data: $response
}