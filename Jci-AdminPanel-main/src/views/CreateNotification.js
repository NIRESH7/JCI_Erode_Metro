import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";

function CreateNotification() {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [notification_type, setNotification_type] = useState("");
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);
  const [notification, setNotification] = useState([]);
  const [render, setRender] = useState(true);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getAllNotification")
      .then((res) => {
        setNotification(res.data.response.data.info);
      });
  }, [render]);
  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      title: title,
      description: description,
      notification_type: notification_type,
    };
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/createNotification",
        data
      )
      .then((res) => {
        setData(res.data);
        setTitle("");
        setDescription("");
        setNotification_type("");
        toast.success("Bussiness Category created successfully!");
        setLoading(false);
        axios
          .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getAllNotification")
          .then((res) => {
            setNotification(res.data.response.data.info);
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

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3 mb-5">
          <h5 className="d-inline-block mb-3">Create Notification </h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name"> Title</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter title"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required={true}
              />
            </div>
          </div>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name"> Description</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter Business Category"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                required={true}
              />
            </div>
          </div>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name"> Member Type</label>{" "}
              <select
                value={notification_type}
                onChange={(e) => setNotification_type(e.target.value)}
                required={false}
                class="form-select"
                id="inputGroupSelect01"
              >
                <option selected>Choose...</option>
                <option value="boardmember">Board Member</option>
                <option value="member">Member</option>
              </select>
            </div>
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
      </form>{" "}
      <div className="container-fluid p-3">
        <table className="table table-sm mt-3">
          <thead className="thead-dark">
            <th>S.No</th>
            <th>Title</th>
            <th>Description</th>

            <th> Member Type</th>
            {/* <th>Delete</th> */}
          </thead>
          <tbody>
            {Array.isArray(notification) && notification.length !== 0 ? (
              notification?.map((x, index) => (
                <tr>
                  <td className="ml-3">{++index}</td>
                  <td style={{ textTransform: "capitalize" }}>{x.title}</td>
                  <td style={{ textTransform: "capitalize" }}>
                    {x.description}
                  </td>
                  <td style={{ textTransform: "capitalize" }}>
                    {x.notification_type}
                  </td>
                  {/* <td style={{textTransform:"capitalize"}}>{x.status}</td> */}
                </tr>
              ))
            ) : (
              <tr>
                <td className="text-center" colSpan="4">
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

export default CreateNotification;
