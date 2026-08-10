import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";

const API = process.env.REACT_APP_URL_ADMIN;

function showResultToast(message) {
  const text = typeof message === "string" ? message : "Something went wrong";
  const failed = /fail|error|already exists/i.test(text);
  if (failed) {
    toast.error(text);
  } else {
    toast.success(text);
  }
  return !failed;
}

function CreateBussinessCategory() {
  const [Business_category, setBusiness_category] = useState("");
  const [business_categoryId, setBusiness_categoryId] = useState("");
  const [Business_subcategory, setBusiness_subcategory] = useState("");
  const [userlist, setUserlist] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);

  const loadCategories = () => {
    axios
      .get(API + "/jciadmin/getAllBusinessName")
      .then((res) => {
        const info = res.data?.response?.data?.info;
        setUserlist(Array.isArray(info) ? info : []);
      })
      .catch(() => setUserlist([]));
  };

  useEffect(() => {
    loadCategories();
  }, []);

  const handleCategorySubmit = (e) => {
    e.preventDefault();
    const name = Business_category.trim();
    if (!name) {
      toast.error("Please enter a business category");
      return;
    }
    setLoading(true);
    setIsError(false);
    axios
      .post(API + "/jciadmin/addBusinessCategory", { Business_name: name })
      .then((res) => {
        const info = res.data?.response?.data?.info;
        const ok = showResultToast(info);
        if (ok) setBusiness_category("");
        setLoading(false);
        loadCategories();
      })
      .catch((err) => {
        const msg =
          err?.response?.data?.error?.message ||
          "Business category creation failed!";
        if (msg === "Authentication Failed") {
          localStorage.clear();
          window.location.reload();
          return;
        }
        setLoading(false);
        setIsError(true);
        toast.error(msg);
      });
  };

  const handleSubCategorySubmit = (e) => {
    e.preventDefault();
    if (!business_categoryId) {
      toast.error("Please select a business category");
      return;
    }
    const name = Business_subcategory.trim();
    if (!name) {
      toast.error("Please enter a business subcategory");
      return;
    }
    setLoading(true);
    setIsError(false);
    axios
      .post(API + "/jciadmin/addBusinessSubCategory", {
        id: business_categoryId,
        Business_name: name,
      })
      .then((res) => {
        const info = res.data?.response?.data?.info;
        const ok = showResultToast(info);
        if (ok) setBusiness_subcategory("");
        setLoading(false);
        loadCategories();
      })
      .catch((err) => {
        const msg =
          err?.response?.data?.error?.message ||
          "Business subcategory creation failed!";
        if (msg === "Authentication Failed") {
          localStorage.clear();
          window.location.reload();
          return;
        }
        setLoading(false);
        setIsError(true);
        toast.error(msg);
      });
  };

  return (
    <div>
      <ToastContainer />
      <form onSubmit={handleCategorySubmit}>
        <div className="container p-3 mb-5">
          <h5 className="d-inline-block mb-3">Create Business Category</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <input
                type="text"
                className="form-control"
                id="category-name"
                placeholder="Enter Business Category"
                value={Business_category}
                onChange={(e) => setBusiness_category(e.target.value)}
                required
              />
            </div>

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
      <form onSubmit={handleSubCategorySubmit}>
        <div className="container p-3 mt-5">
          <h5 className="d-inline-block mb-3">Create Business SubCategory</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="input-group mb-3">
              <select
                value={business_categoryId}
                onChange={(e) => setBusiness_categoryId(e.target.value)}
                className="form-select"
              >
                <option value="" disabled>
                  Select Business Category
                </option>
                {userlist
                  .filter((user) => Number(user.parent_Id) === 0)
                  .map((user) => (
                    <option
                      key={user.id}
                      style={{ textTransform: "capitalize" }}
                      value={user.id}
                    >
                      {String(user.Business_name || "")
                        .toLowerCase()
                        .replace(/\b\w/g, (char) => char.toUpperCase())}
                    </option>
                  ))}
              </select>
            </div>
            <div className="form-group">
              <input
                type="text"
                className="form-control"
                id="subcategory-name"
                placeholder="Enter Business SubCategory"
                value={Business_subcategory}
                onChange={(e) => setBusiness_subcategory(e.target.value)}
                required
              />
            </div>
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
