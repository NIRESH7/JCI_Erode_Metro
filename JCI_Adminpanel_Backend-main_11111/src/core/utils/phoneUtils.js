export const normalizePhone = (phone) => {
  if (!phone) return "";
  let digits = String(phone).replace(/\D/g, "");
  if (digits.length === 10) {
    digits = "91" + digits;
  }
  if (digits.length >= 10) {
    return "+" + digits;
  }
  return phone.startsWith("+") ? phone : "+" + digits;
};

export const phonesMatch = (a, b) => {
  const na = normalizePhone(a).replace(/\D/g, "");
  const nb = normalizePhone(b).replace(/\D/g, "");
  return na.slice(-10) === nb.slice(-10);
};
