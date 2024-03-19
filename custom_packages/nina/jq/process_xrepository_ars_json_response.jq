input? // null |
(if $ARGS.named.district == null then null else $ARGS.named.district end) as $district |
(if $ARGS.named.city == null then null else $ARGS.named.city end) as $city | 
(try . catch null) as $raw |
(try $raw.metadaten catch null) as $metadaten | 
(try
    [
        $raw.spalten[].spaltennameLang |
        (.[:1]|ascii_upcase) + (.[1:]|ascii_downcase)
    ]
catch null) as $spalten | 
(try
    (
        [
            $raw.daten[] |
            {
                ($spalten[0]): .[0],
                ($spalten[1]): .[1],
                ($spalten[2]): .[2]
            } |
            select(
              .Bezeichnung |
              test("^\($district)$|^\($city)$"; "i")
            )
        ]
    )
catch null) as $daten | 
(if $district != null and $city != null and $metadaten != null and $daten != null then "OK" else "Error" end) as $status |
(if $status == "OK" then
    $metadaten |
    {
        kennungInhalt,
        version,
        gueltigAb,
        nameKurz: .nameKurz[].value,
        nameLang: .nameLang[].value,
        herausgebernameKurz: .herausgebernameKurz[].value,
        herausgebernameLang: .herausgebernameLang[].value,
        beschreibung: .beschreibung[].value,
        daten: $daten
    }
else null end) as $response |
{
    status: $status,
    data: $response
}