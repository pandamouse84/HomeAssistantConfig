input? // null |
(try .result catch null) as $raw |
(if $raw != null then $raw else null end) as $response |
    (
        try first(.loadpoints[]) catch null
    ) as $loadpoints |
try $loadpoints.enabled catch null |
    . as $enabled |
(if $raw != null and $response != null and $loadpoints != null and $enabled != null then "OK" else "Error" end) as $status |
{
    status: $status,
    data: $response
}