import React from "react";
import "./ListToolbar.css";

/**
 * Shared search bar for admin list pages.
 */
function ListToolbar({
  title,
  search,
  onSearchChange,
  placeholder = "Search…",
  count,
  countLabel = "results",
}) {
  return (
    <div className="list-toolbar">
      {title ? <h2 className="list-toolbar__title">{title}</h2> : null}
      <div className="list-toolbar__row">
        <div className="list-toolbar__search">
          <i className="fas fa-search" aria-hidden="true" />
          <input
            type="search"
            value={search}
            onChange={(e) => onSearchChange(e.target.value)}
            placeholder={placeholder}
            aria-label={placeholder}
          />
          {search ? (
            <button
              type="button"
              className="list-toolbar__clear"
              onClick={() => onSearchChange("")}
              aria-label="Clear search"
            >
              ×
            </button>
          ) : null}
        </div>
        {typeof count === "number" ? (
          <span className="list-toolbar__count">
            {count} {countLabel}
          </span>
        ) : null}
      </div>
    </div>
  );
}

export function matchesSearch(row, query, fields) {
  const q = String(query || "").trim().toLowerCase();
  if (!q) return true;
  return fields.some((key) => {
    const val = row?.[key];
    return val != null && String(val).toLowerCase().includes(q);
  });
}

export default ListToolbar;
