input? // null |
.getStammdatenResult as $raw |
try $raw[] catch null |
    (
        try first(.Parameter[]) catch null |
        try first(.Datenspuren[]) catch null
    ) as $measurements |
try $measurements.AktuellerMesswert_Zeitpunkt catch null |
    try strptime("%d.%m.%Y") catch null |
    try mktime catch null |
    try todate catch null |
    . as $date |
(if $raw != null and $measurements != null and $measurements.AktuellerPegelstand.Wert != null and $date != null then "OK" else "Error" end) as $status |
(if $status == "OK" then 
    {
        stationID: $raw[].STA_ID,
        Datum: $date,
        Wert: $measurements.AktuellerPegelstand.Wert,
        Grundwasserstandsklasse: $measurements.AktuellerPegelstand.Grundwasserstandsklasse,
        mnw: $raw[].StatistikNiedrigwasser.Wert,
        mhw: $raw[].StatistikHochWasser.Wert
    }
else null end ) as $response |
{
    status: $status,
    data: $response
}