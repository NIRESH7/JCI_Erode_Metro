import React, { useState, useEffect } from "react";
import axios from "axios";
import { withRouter } from "react-router";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";

function CreateEventImage(props) {
  const [event_id, setEvent_id] = useState("");
  const [eventlist, setEventlist] = useState([]);
  const [event_name, setEvent_name] = useState("");
  const [image, setImage] = useState("");
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  console.log("njhbjh", props);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/member/allevents")
      .then((res) => {
        console.log(res.data.response.data.info);
        setEventlist(res.data.response.data.info);
      });
  }, [props.location.pathname]);
  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      event_id: event_id,
      event_name: event_name,
      image: image,
    };

    const formdata = new FormData();
    Object.entries(data).map((data) => {
      console.log(data);
      formdata.append(data[0], data[1]);
    });
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/createEventImage",
        formdata
      )
      .then((res) => {
        setEvent_id("");
        setEvent_name("");
        setIsError(false);
        toast.success("Image Uploaded successfully!");
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
        toast.error("Image Uploaded  failed!");
      });
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3">
          <h5 className="d-inline-block mb-3">CREATE EVENT IMAGE</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name">Event Name</label>
              <div className="input-group mb-3">
                <select
                  required={false}
                  onChange={(e) => {
                    setEvent_id(eventlist[e.target.value].id);
                    setEvent_name(eventlist[e.target.value].event_name);
                  }}
                  className="form-select"
                >
                  <option value="">select</option>
                  {Array.isArray && eventlist.length !== 0
                    ? eventlist.map((user, index) => (
                        <option
                          style={{ textTransform: "capitalize" }}
                          value={index}
                        >
                          {user.event_name}
                        </option>
                      ))
                    : false}
                </select>
              </div>
            </div>
            <div className="form-group">
              <label htmlFor="name">Upload Event Image</label>
              <input
                type="file"
                className="form-control"
                id="image"
                onChange={(e) => {
                  if (e.target.files) setImage(e.target.files[0]);
                }}
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

export default withRouter(CreateEventImage);
