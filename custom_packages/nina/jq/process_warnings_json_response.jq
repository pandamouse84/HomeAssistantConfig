input? // null |
(try [.[].info[] | select(.language | test("^de-de|de$"; "i"))] catch null) as $raw |
(try [$raw[] |
    setpath(
        ["severity_ha"]; (
            .severity |
            sub("^((?!Severe|Extreme|Moderate).)*$"; "info"; "i") |
            sub("Severe"; "error"; "i") |
            sub("Extreme"; "error"; "i") |
            sub("Moderate"; "warning"; "i")
        )
    )
] catch null) as $raw_severity |
(try [$raw_severity[] |
    setpath(
        ["urgency_ha"]; (
            .urgency |
            sub("(?<urgency>^(?!Immediate|Expected|Future).*$)"; "Maßnahmen-Status: \(.urgency)" ; "i") |
            sub("Immediate"; "Maßnahmen sollten sofort ergriffen werden."; "i") |
            sub("Expected"; "Maßnahmen sollten bald (innerhalb der nächsten Stunde) ergriffen werden."; "i") |
            sub("Future"; "Maßnahmen sollten in naher Zukunft ergriffen werden."; "i")
        )
    )
] catch null) as $raw_severity_urgency |
"OK" as $status |
(if ($raw_severity_urgency | length) > 0 then
    [
        try $raw_severity_urgency[] catch null |
        {
            event,
            urgency,
            severity,
            headline,
            description,
            web,
            instruction,
            severity_ha,
            urgency_ha
        }
    ]
else null end) as $response |
{
    status: $status,
    data: $response
}