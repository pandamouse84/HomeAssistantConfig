input? // null |
(if $ARGS.named.street == null then "Lerchenkamp" else $ARGS.named.street end) as $street |
(if $ARGS.named.city == null then "Hornbostel" else $ARGS.named.city end) as $city |
(try
    [
        .[] |
        select(
            .name |
            test("^\($street)$|^\($street) \\(\($city)\\)$"; "i")
        )
    ]    
catch null) as $response |
(if $street != null and $city != null and $response != null and ($response | length) > 0 then "OK" else "Error" end) as $status |
(if $status == "Error" then null else $response end) as $response |
{
    status: $status,
    data: $response
}