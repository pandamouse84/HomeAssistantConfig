# <summary>
# This JQ filter is used to filter all EZ1 rest queries.
# The response message is converted to the status attribute of OK and ERROR.
# The response body is converted to the data attribute.
# Use with JQ null input flag -n.
# </summary>
# <remarks>
# =========================================================================
# Date         Author        Comment
# 2024-03-11   FZE           Initial release
# =========================================================================
# </remarks>

input? // null |
. as $raw |
(if $raw.message != null and $raw.message == "SUCCESS" then "OK" else "Error" end) as $status |
(if $status == "OK" then $raw.data else null end) as $response |
{
    status: $status,
    data: $response
}