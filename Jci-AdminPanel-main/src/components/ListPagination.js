import React from "react";
import "./ListPagination.css";

export const PAGE_SIZE = 10;

export function paginate(items, page, pageSize = PAGE_SIZE) {
  const list = Array.isArray(items) ? items : [];
  const totalPages = Math.max(1, Math.ceil(list.length / pageSize));
  const safePage = Math.min(Math.max(1, page), totalPages);
  const start = (safePage - 1) * pageSize;
  return {
    page: safePage,
    totalPages,
    total: list.length,
    slice: list.slice(start, start + pageSize),
  };
}

function ListPagination({ page, totalPages, total, onPageChange, pageSize = PAGE_SIZE }) {
  if (!total) return null;

  const start = (page - 1) * pageSize + 1;
  const end = Math.min(page * pageSize, total);

  return (
    <div className="list-pagination">
      <span className="list-pagination__info">
        Showing {start}–{end} of {total}
      </span>
      <div className="list-pagination__controls">
        <button
          type="button"
          className="list-pagination__btn"
          disabled={page <= 1}
          onClick={() => onPageChange(page - 1)}
        >
          Previous
        </button>
        <span className="list-pagination__page">
          Page {page} of {totalPages}
        </span>
        <button
          type="button"
          className="list-pagination__btn"
          disabled={page >= totalPages}
          onClick={() => onPageChange(page + 1)}
        >
          Next
        </button>
      </div>
    </div>
  );
}

export default ListPagination;
