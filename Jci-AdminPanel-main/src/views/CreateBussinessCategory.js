import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";

function CreateBussinessCategory() {
  const [member_id, setMember_id] = useState("");
  const [Business_category, setBusiness_category] = useState("");
  const [business_categoryId, setBusiness_categoryId] = useState("");
  const [Business_subcategory, setBusiness_subcategory] = useState("");
  const [userlist, setUserlist] = useState([]);
  const [role, setRole] = useState();

  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);
  const [roles, setRoles] = useState([]);

  console.log(userlist);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getAllBusinessName")
      .then((res) => {
        setUserlist(res.data.response.data.info);
      });
  }, []);
  const handleCategorySubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      Business_name: Business_category,
    };
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/addBusinessCategory",
        data
      )
      .then((res) => {
        setData(res.data);
        setBusiness_category("");

        toast.success(res.data.response.data.info);
        setLoading(false);

        axios
          .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getAllBusinessName")
          .then((res) => {
            setUserlist(res.data.response.data.info);
          });
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
        toast.error("Bussiness category creation failed!");
      });
  };
  console.log(business_categoryId);
  const handleSubCategorySubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      id: business_categoryId,
      Business_name: Business_subcategory,
    };
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/addBusinessSubCategory",
        data
      )
      .then((res) => {
        setData(res.data);
        setBusiness_subcategory("");

        toast.success(res.data.response.data.info);
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
        toast.error("Business subcategory creation failed!");
      });
  };
  const handleCategoryChange = (e) => {
    setBusiness_categoryId(e.target.value);
  };
  return (
    <div>
      <form onSubmit={handleCategorySubmit}>
        <div className="container p-3 mb-5">
          <h5 className="d-inline-block mb-3">Create Business Category</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter Business Category"
                value={Business_category}
                onChange={(e) => setBusiness_category(e.target.value)}
                required={true}
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
      </form>{" "}
      <form onSubmit={handleSubCategorySubmit}>
        <div className="container p-3 mt-5">
          <h5 className="d-inline-block mb-3">Create Business SubCategory</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="input-group mb-3">
              <select
                  value={business_categoryId}
                  onChange={handleCategoryChange}
                className="form-select"
              >
                <option value="" disabled>
                  Select Business Category
                </option>
                {userlist
                  .filter((user) => user.parent_Id === 0)
                  .map((user) => (
                    <option
                      style={{ textTransform: "capitalize" }}
                      value={user.id}
                    >
                      {user.Business_name.toLowerCase().replace(
                        /\b\w/g,
                        (char) => char.toUpperCase()
                      )}
                    </option>
                  ))}
              </select>
            </div>
            <div className="form-group">
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter Business SubCategory"
                value={Business_subcategory}
                onChange={(e) => setBusiness_subcategory(e.target.value)}
                required={true}
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

export default CreateBussinessCategory;
