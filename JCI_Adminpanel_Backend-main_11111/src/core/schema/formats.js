export const schemaFormats = {
    onlyAlpha: val => /^[a-zA-Z ]+$/.test(val),
    desc: val => /^[ a-zA-Z_./#+-,;$!]+$/.test(val),
    alphaNumeric: val => /^[a-zA-Z0-9]+$/.test(val),
    numeric: val => /^[0-9]+$/.test(val),
    pincode: val => /^[1-9][0-9]{5}$/.test(val)
}