input? // null |
. as $raw |
(try [$raw[].id] catch null) as $response |
{
    status: "OK",
    data: $response
}