import React, { useState, useEffect } from "react";
import axios from "axios";
import moment from "moment";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";
import { useParams } from "react-router-dom";
function UpdateEvent() {
  const { id } = useParams();
  const [event_name, setEvent_name] = useState("");
  const [image, setImage] = useState("");
  const [event_date, setEvent_date] = useState("");
  const [event_time, setEvent_time] = useState("");
  const [event_location, setEvent_location] = useState("");
  const [event_desc, setEvent_desc] = useState("");
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);
  const handleSubmit = (e) => {
    e.currentTarget.reset();
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      id: id,
      event_name: event_name,
      image: image,
      event_date: event_date,
      event_time: event_time,
      event_location: event_location,
      event_desc: event_desc,
    };
    const formdata = new FormData();
    Object.entries(data).map((data) => {
      data;
      formdata.append(data[0], data[1]);
    });
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/editEvent", formdata)
      .then((res) => {
        setData(res.data);
        toast.success("Event Updated Successfully!");
        setLoading(false);
      })
      .catch((err) => {
        console.log("Response", err.response);
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
        toast.error("Event Creation failed!");
      });
  };

  const validateSize = (event) => {
    let file = event.target.files[0];
    let size = 50000;
    let err = "";

    if (file.size > size) {
      err = file.type + "is too large, please pick a smaller file\n";
    }
  };
  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/member/allevents")
      .then((res) => {
        res.data.response.data.info
          .filter((e) => id == e.id)
          .map((data) => {
            setEvent_name(data.event_name);
            setImage(data.event_image);
            // moment(setEvent_date(data.event_date)).format("YYYY-MM-DD")
            setEvent_date("01-02-1997");
            setEvent_time("22:19");
            setEvent_location(data.event_location);
            setEvent_desc(data.event_desc);
          });
      });
  }, []);
  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3">
          <h5 className="d-inline-block mb-3">UPDATE EVENT</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name">Event Name</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter Name"
                value={event_name}
                required={true}
                onChange={(e) => setEvent_name(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Event Image</label>
              <input
                type="file"
                className="form-control"
                id="image"
                onChange={(e) => {
                  if (e.target.files) setImage(e.target.files[0]);
                  if (validateSize(e));
                }}
                required={true}
              />
              <span style={{ color: "Red" }}>Max size 5mb</span>
            </div>
            <div className="form-group">
              <label htmlFor="name">Event Date</label>
              <input
                type="date"
                className="form-control"
                id="name"
                value={event_date}
                required={true}
                onChange={(e) => setEvent_date(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Time</label>
              <input
                type="time"
                className="form-control timepicker"
                id="name"
                placeholder="Enter Time"
                value={event_time}
                required={true}
                onChange={(e) => setEvent_time(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Event Location</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter Location"
                value={event_location}
                required={true}
                onChange={(e) => setEvent_location(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Event Description</label>
              <textarea
                className="form-control"
                id="name"
                required={true}
                placeholder="Enter Description"
                value={event_desc}
                onChange={(e) => setEvent_desc(e.target.value)}
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

export default UpdateEvent;
