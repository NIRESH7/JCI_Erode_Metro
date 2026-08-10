import React from "react";
import { useHistory } from "react-router-dom";
import "./BackButton.css";

/**
 * Back navigation for detail / edit pages.
 * Uses browser history when available, otherwise falls back to `to`.
 */
function BackButton({ to = "/admin/dashboard", label = "Back" }) {
  const history = useHistory();

  const handleClick = () => {
    if (history.length > 1) {
      history.goBack();
      return;
    }
    history.push(to);
  };

  return (
    <button type="button" className="metro-back-btn" onClick={handleClick}>
      <i className="fas fa-arrow-left" aria-hidden="true" />
      <span>{label}</span>
    </button>
  );
}

export default BackButton;
