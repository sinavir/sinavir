{
  attrsOrDefault = as: a: default:
    if as ? a
    then as.${a}
    else default;
}
