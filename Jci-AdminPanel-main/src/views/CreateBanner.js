import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";
import srxc from "../assets/img/img.svg";

const API_BASE = (process.env.REACT_APP_URL_ADMIN || "http://localhost:3002").replace(
  /\/$/,
  ""
);

/** Point stored banner URLs (production / old LAN) at the local API. */
function resolveBannerUrl(url) {
  if (!url) return "";
  const trimmed = String(url).trim();
  if (!trimmed) return "";
  if (trimmed.startsWith("/")) return `${API_BASE}${trimmed}`;
  try {
    const parsed = new URL(trimmed);
    const host = parsed.hostname.toLowerCase();
    const rewrite =
      host.includes("jcierodemetro") ||
      host.includes("jcierodegreencity") ||
      host === "localhost" ||
      host === "127.0.0.1" ||
      host.startsWith("192.168.") ||
      host.startsWith("10.");
    if (rewrite) return `${API_BASE}${parsed.pathname}`;
    return trimmed;
  } catch (_) {
    const idx = trimmed.indexOf("/images/");
    if (idx >= 0) return `${API_BASE}${trimmed.substring(idx)}`;
    return trimmed;
  }
}

function CreateBanner() {
  const [image, setImage] = useState("");
  const [bannerlist, setBannerList] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [data, setData] = useState(false);

  useEffect(() => {
    axios
      .get(API_BASE + "/jciadmin/getBanners")
      .then((res) => {
        setBannerList(res.data.response.data.info);
      })
      .catch(() => setBannerList([]));
  }, [data]);

  const handleSubmit = () => {
    if (!image) {
      setIsError(true);
      setErrorMessage("Please select an image file.");
      return;
    }
    setLoading(true);
    setIsError(false);
    setErrorMessage("");
    const formdata = new FormData();
    formdata.append("image", image);
    axios
      .post(API_BASE + "/jciadmin/createBanners", formdata)
      .then((res) => {
        setData(res.data);
        setImage("");
        setLoading(false);
        toast.success("Banner created successfully!");
      })
      .catch((err) => {
        let message = "Something went wrong. Please try again later.";
        if (err?.response?.data?.Error) {
          message = err.response.data.Error;
        } else if (err?.response?.data?.error?.message) {
          message = err.response.data.error.message;
        }
        if (err.response?.data?.error?.message === "Authentication Failed") {
          localStorage.clear();
          window.location.reload();
        }
        setLoading(false);
        setIsError(true);
        setErrorMessage(message);
        toast.error("Banner creation failed!");
      });
  };

  return (
    <div className="container p-3">
      <h5 className="d-inline-block mb-3">CREATE BANNER</h5>
      <div style={{ maxWidth: 600 }}>
        <div className="form-group">
          <label htmlFor="image">Banner Image</label>
          <input
            type="file"
            className="form-control"
            id="image"
            accept="image/png,image/jpeg,image/jpg,image/webp,image/svg+xml"
            onChange={(e) => {
              if (e.target.files) setImage(e.target.files[0]);
            }}
            required={true}
          />
        </div>
        <ToastContainer />

        {isError && (
          <small className="mt-3 d-inline-block text-danger">
            {errorMessage || "Something went wrong. Please try again later."}
          </small>
        )}
        <button
          type="submit"
          className="btn btn-primary mt-3"
          onClick={handleSubmit}
          disabled={loading}
        >
          {loading ? "Loading..." : "Submit"}
        </button>
        <div className="container-fluid py-3"></div>
        <table className="table table-sm mt-3">
          <thead className="thead-dark">
            <tr>
              <th>Banner image</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {Array.isArray(bannerlist) && bannerlist.length !== 0 ? (
              bannerlist.map((x) => (
                <tr key={x.id}>
                  <td>
                    <img
                      src={resolveBannerUrl(x.banner_image)}
                      onError={(e) => {
                        e.currentTarget.src = srxc;
                      }}
                      width="50"
                      height="50"
                      alt="banner"
                    />
                  </td>
                  <td>
                    <a
                      style={{ cursor: "pointer" }}
                      onClick={() =>
                        axios
                          .post(API_BASE + "/jciadmin/deleteBanners", { id: x.id })
                          .then(() => setData(!data))
                      }
                      className="badge badge-danger m-2"
                    >
                      <i className="bx bx-user-check"> </i> Delete
                    </a>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td className="text-center" colSpan="2">
                  <b>No data found to display.</b>
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
export default CreateBanner;
