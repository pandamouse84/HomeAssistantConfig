input? // null |
(if $ARGS.named.regionid == null then 30 else $ARGS.named.regionid end) as $regionid | 
(if $ARGS.named.partregionid == null then 32 else $ARGS.named.partregionid end) as $partregionid | 
. as $raw |
$raw.legend |
    [
        try keys[] catch empty |
        capture("^id(?<id>\\d+$)"; "ig").id
    ] as $ids |
    $ids |
    map(
        {
            (. | tonumber -1 | tostring):
                {
                    id: ($raw.legend["id" + .]),
                    description: ($raw.legend["id" + . + "_desc"]),
                    severity: (. | tonumber -1)
                }
        }
    ) |
    add |
    flatten as $legend |
$raw.content |
    try .[] catch null |
    (if (.partregion_id == null | not) and (.region_id == null | not) then
        select(.partregion_id == $partregionid) |
        select(.region_id == $regionid)
    else
        null
    end) as $content |
$content.Pollen |
    (try with_entries(.value |= with_entries(.value |= . as $item | ($legend[] | select(.id == $item)))) catch null) as $pollen |
(if $legend == null or $pollen == null then "ERROR" else "OK" end) as $status |
(if $status == "OK" then 
    {
        name: $raw.name,
        sender: $raw.sender,
        region_id: $content.region_id,
        region_name: $content.region_name,
        partregion_id: $content.partregion_id,
        partregion_name: $content.partregion_name,
        last_update: $raw.last_update,
        next_update: $raw.next_update,
        legend: $legend,
        content: $pollen
    }
else null end ) as $response |
{
    status: $status,
    data: $response
}