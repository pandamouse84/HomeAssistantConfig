input? // null |
. as $raw |
$raw |
    test(".*good.*"; "i") as $check |
(if $check then "OK" else "Error" end) as $status |
{
    status: $status,
    raw: $raw
}