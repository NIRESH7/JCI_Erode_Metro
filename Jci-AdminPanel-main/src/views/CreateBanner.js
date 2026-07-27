import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";
import srxc from "../assets/img/img.svg";
// react-bootstrap components

function CreateBanner() {
  const [image, setImage] = useState("");
  const [bannerlist, setBannerList] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [data, setData] = useState(false);

  useEffect(() => {
    // console.log("hello0s")
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getBanners")
      .then((res) => {
        setBannerList(res.data.response.data.info);
      })
      .catch((data) => setBannerList([]));
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
    const data = {
      image: image,
    };
    const formdata = new FormData();
    Object.entries(data).map((data) => {
      formdata.append(data[0], data[1]);
    });
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/createBanners",
        formdata
      )
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
        setErrorMessage(message);
        toast.error("Banner creation failed!");
      });
  };

  return (
    <div className="container p-3">
      <h5 className="d-inline-block mb-3">CREATE BANNER</h5>
      <div style={{ maxWidth: 600 }}>
        <div className="form-group">
          <label htmlFor="name">Banner Image</label>
          <input
            type="file"
            className="form-control"
            id="image"
            accept="image/png,image/jpeg,image/jpg,image/webp,image/svg+xml"
            // value={image}
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
        {/* <div className="container-fluid p-3"> */}
        <div className="container-fluid py-3"></div>
        <table className="table table-sm mt-3">
          <thead className="thead-dark">
            {/* <th >S.No</th> */}
            <th>Banner image</th>
            <th>Action</th>
          </thead>
          <tbody>
            {Array.isArray(bannerlist) && bannerlist.length !== 0 ? (
              bannerlist.map((x) => (
                <tr>
                  {/* <td>{x.id}</td> */}
                  <td>
                    {console.log("values", x)}
                    <img
                      src={x.banner_image}
                      onError={(e) => (e.currentTarget.src = srxc)}
                      width="50"
                      height="50"
                      alt="image"
                    />
                  </td>

                  <td>
                    <a
                      style={{ cursor: "pointer" }}
                      onClick={() =>
                        axios
                          .post(
                            process.env.REACT_APP_URL_ADMIN +
                              "/jciadmin/deleteBanners",
                            { id: x.id }
                          )
                          .then((res) => setData(!data))
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
                {" "}
                <td className="text-center" colSpan="4">
                  <b>No data found to display.</b>
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
    // </div>
  );
}
export default CreateBanner;
