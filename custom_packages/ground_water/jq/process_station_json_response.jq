input? // null |
.getStammdatenResult as $raw |
(if $raw != null and ($raw | type) == "array" and ($raw | length) > 0 then "OK" else "Error" end) as $status |
(if $status == "OK" then
    [
        try $raw[] catch null |
        {
            latitude: .Longitude | tonumber,
            longitude: .Latitude | tonumber,
            altitude: .Hoehe | tonumber,
            stationID: .STA_ID,
            ort: .Ort,
            gewaesserName: .Gewaesser_Koerper,
            name: .Name
        }
    ]
else null end) as $response |
{
    status: $status,
    data: $response
}