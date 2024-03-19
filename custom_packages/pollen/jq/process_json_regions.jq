input? // null |
(try . catch null) as $raw |
(try
    (
        $raw |
        {
            name,
            sender,
            last_update,
            next_update,
            content:
            [
                .content[] |
                (
                    if .partregion_id == -1 then
                    {
                        name: .region_name,
                        region_id,
                        partregion_id
                    }
                    else
                    {
                        name: .partregion_name,
                        region_id,
                        partregion_id
                    }
                    end
                )
            ]
        }
    )
catch null) as $data |
(if $raw != null and $data != null and ($data | length) > 0 then "OK" else "Error" end) as $status |
(if $status == "OK" then $data else null end) as $response |
{
    status: $status,
    data: $response
}