cat npins/sources.json | jq -r '.pins | keys | .[]' | sed '/netboot/d' | xargs npins update
