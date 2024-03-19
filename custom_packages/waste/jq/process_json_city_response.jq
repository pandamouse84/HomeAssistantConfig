input? // null |
(if $ARGS.named.district == null then null else $ARGS.named.district end) as $district |
(if $ARGS.named.city == null then null else $ARGS.named.city end) as $city | 
(try
    [
        .[] |
        select(
            .name |
            test("^\($district)$|^\($city)$"; "i")
        )
    ]    
catch null) as $response |
(if $district != null and $city != null and $response != null and ($response | length) > 0 then "OK" else "Error" end) as $status |
(if $status == "Error" then null else $response end) as $response |
{
    status: $status,
    data: $response
}