input? // null |
(try .result catch null) as $raw |
(if $raw != null then $raw else null end) as $response |
(try first($response.loadpoints[]) catch null) as $loadpoint |
(if $raw != null and $response != null and $loadpoint != null and $loadpoint.enabled != null then "OK" else "Error" end) as $status |
{
    status: $status,
    data: $response
}