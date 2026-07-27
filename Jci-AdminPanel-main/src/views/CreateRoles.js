import React, { useState } from "react";
import axios from "axios";
import Rolelist from "../views/Rolelist";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";

function CreateRoles() {
  const [role, setRole] = useState("");
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [refreshKey, setRefreshKey] = useState(0);

  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      role: role,
    };
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/createRoles", data)
      .then(() => {
        setIsError(false);
        setRole("");
        setRefreshKey((k) => k + 1);
        toast.success("Roles created successfully!");
        setLoading(false);
      })
      .catch((err) => {
        if (
          err.response &&
          err.response.data &&
          err.response.data.error &&
          typeof err.response.data.error.message === "string"
        ) {
          if (err.response.data.error.message === "Authentication Failed") {
            localStorage.clear();
            window.location.reload();
          }
          setIsError(err.response.data.error.message);
        } else setIsError(true);
        setLoading(false);

        toast.error("Roles creation failed!");
      });
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3">
          <h5 className="d-inline-block mb-3">CREATE ROLES</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="role">Role Name</label>
              <input
                type="text"
                className="form-control"
                id="role"
                required={true}
                placeholder="Example:Member"
                value={role}
                onChange={(e) => setRole(e.target.value)}
              />
            </div>
            <ToastContainer />
            {isError && (
              <small className="mt-3 d-inline-block text-danger">
                {typeof isError === "boolean"
                  ? "Something went wrong. Please try again later."
                  : isError}
              </small>
            )}
            <button
              type="submit"
              className="btn btn-primary mt-3"
              disabled={loading}
            >
              {loading ? "Loading..." : "Submit"}
            </button>
          </div>
        </div>
      </form>
      <Rolelist refreshKey={refreshKey} />
    </div>
  );
}

export default CreateRoles;
