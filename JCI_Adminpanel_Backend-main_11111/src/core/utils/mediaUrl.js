/**
 * Rewrites stored media URLs (production / LAN) to the current HS_IMAGE base.
 * Keeps the /images/... path so local static serving works.
 */
export function resolvePublicMediaUrl(url) {
  const base = (process.env.HS_IMAGE || "http://127.0.0.1:3002").replace(/\/$/, "");
  if (!url || typeof url !== "string") return url;

  const trimmed = url.trim();
  if (!trimmed || trimmed.includes("placeholder.jpg")) return trimmed;

  if (trimmed.startsWith("/")) {
    return `${base}${trimmed}`;
  }

  try {
    const parsed = new URL(trimmed);
    const host = parsed.hostname.toLowerCase();
    const shouldRewrite =
      host.includes("jcierodemetro") ||
      host.includes("jcierodegreencity") ||
      host === "localhost" ||
      host === "127.0.0.1" ||
      host.startsWith("192.168.") ||
      host.startsWith("10.") ||
      host.endsWith(".local");

    if (shouldRewrite) {
      return `${base}${parsed.pathname}`;
    }
    return trimmed;
  } catch (_) {
    if (trimmed.includes("/images/")) {
      const path = trimmed.substring(trimmed.indexOf("/images/"));
      return `${base}${path}`;
    }
    return `${base}/${trimmed.replace(/^\//, "")}`;
  }
}

export function mapMediaFields(row, fields = []) {
  if (!row) return row;
  const plain = typeof row.toJSON === "function" ? row.toJSON() : { ...row };
  for (const field of fields) {
    if (plain[field] != null) {
      plain[field] = resolvePublicMediaUrl(plain[field]);
    }
  }
  return plain;
}
