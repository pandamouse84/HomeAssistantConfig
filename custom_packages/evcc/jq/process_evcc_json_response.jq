input? // null |
(try .result catch null) as $raw |
(if $raw != null then $raw else null end) as $response |
(if $raw != null and $response != null then "OK" else "Error" end) as $status |
{
    status: $status,
    data: $response
}