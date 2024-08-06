input? // null |
(try .result catch null) as $raw |
(if $raw != null then $raw else null end) as $response |
(try first($response.loadpoints[]) catch null) as $loadpoint |
(
    if
        $raw != null
        and $response != null
        and $loadpoint != null
        and $loadpoint.enabled != null
        and $loadpoint.title != null
        and $loadpoint.vehicleName != null
        and $loadpoint.vehicleSoc != null
        and $loadpoint.vehicleRange != null
        and $loadpoint.connected != null
        and $loadpoint.charging != null
        and $loadpoint.chargePower != null
    then
        "OK"
    else
        "Error"
    end
) as $status |
{
    status: $status,
    data: $response
}