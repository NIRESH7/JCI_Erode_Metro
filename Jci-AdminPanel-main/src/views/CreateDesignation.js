import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";

function CreateDesignation() {
  const [member_id, setMember_id] = useState("");
  const [designation_name, setDesignation_name] = useState("");
  const [designation_year, setDesignation_year] = useState("");
  const [userlist, setUserlist] = useState([]);
  const [role, setRole] = useState();

  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);
  const [roles, setRoles] = useState([]);
  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getRoles")
      .then((res) => {
        setRoles(res.data.response.data.info);
      });
  }, []);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/member/allmembers")
      .then((res) => {
        setUserlist(res.data.response.data.info);
      });
  }, []);
  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      designation_name: designation_name,
      designation_year: designation_year,
      member_id: member_id,
    };
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/createDesignation",
        data
      )
      .then((res) => {
        setData(res.data);
        setDesignation_name("");
        setDesignation_year("");
        setMember_id("");
        toast.success("Designation created successfully!");
        setLoading(false);
      })
      .catch((err) => {
        if (
          err.response &&
          err.response.data &&
          err.response.data.error &&
          typeof err.response.data.error.message === "string"
        )
          if (err.response.data.error.message === "Authentication Failed") {
            localStorage.clear();
            window.location.reload();
          }
        setLoading(false);
        setIsError(true);
        toast.error("Designation creation failed!");
      });
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3">
          <h5 className="d-inline-block mb-3">Role of Honour</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name">Name</label>
              <div className="input-group mb-3">
                <select
                  onChange={(e) => setMember_id(e.target.value)}
                  className="form-select"
                >
                  <option value="">select</option>
                  {userlist.map((user) => (
                    <option
                      style={{ textTransform: "capitalize" }}
                      value={user.id}
                    >
                      {user.user_name}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            {/* <div className="form-group">
          <label htmlFor="name">ID</label>
          <input
            type="number"
            className="form-control"
            id="name"
            placeholder="Enter id number"
            value={member_id}
            onChange={(e) => setMember_id(e.target.value)}
            required={true}
          />
        </div>
         */}
            {/* <div className="form-group">
          <label htmlFor="name">Designation</label>  
          <div className="input-group mb-3">
          <select value={designation_name}  onChange={(e) => setDesignation_name(e.target.value)} className="form-select" id="inputGroupSelect01">
           <option   selected>Choose...</option>
           <option>President</option>
           <option>Member</option>
           </select>
</div> 
        </div> */}

            <div className="form-group">
              <label htmlFor="name">Role</label>
              <div className="input-group mb-3">
                <select
                  onChange={(e) => setDesignation_name(e.target.value)}
                  className="form-select"
                >
                  <option value="">select</option>
                  {roles.map((user) => (
                    <option
                      style={{ textTransform: "capitalize" }}
                      value={user.role_name}
                    >
                      {user.role_name}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="name">Year</label>
              <input
                type="text"
                maxLength="4"
                className="form-control"
                id="name"
                placeholder="Enter year"
                value={designation_year}
                onChange={(e) => setDesignation_year(e.target.value)}
                required={false}
              />
            </div>
            <ToastContainer />

            {isError && (
              <small className="mt-3 d-inline-block text-danger">
                Something went wrong. Please try again later.
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
    </div>
  );
}

export default CreateDesignation;
