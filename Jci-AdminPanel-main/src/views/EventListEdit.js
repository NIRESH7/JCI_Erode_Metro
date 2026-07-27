import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";

function EventListEdit() {
  const query = new URLSearchParams(location.search);
  const qid = query.get("q");
  const [event_name, setEvent_name] = useState("");
  const [event_image, setEvent_image] = useState("");
  const [event_date, setEvent_date] = useState("");
  const [event_time, setEvent_time] = useState("");
  const [event_location, setEvent_location] = useState("");
  const [event_desc, setEvent_desc] = useState("");
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      event_name: event_name,
      event_image: event_image,
      event_date: event_date,
      event_time: event_time,
      event_location: event_location,
      event_desc: event_desc,
    };
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/member/event", { id: qid })
      .then((res) => {
        setData(res.data.response.data.info);

        setData(res.data);
        setEvent_name("");
        setEvent_image("");
        setEvent_date("");
        setEvent_time("");
        setEvent_location("");
        setEvent_desc("");
        toast.success("Event created successfully!");
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

        toast.success("Event creation failed!");
        // setLoading(false);
        //setIsError(true);
      });
  };
  useEffect(() => {
    handleSubmit();
  }, []);
  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3">
          <h5 className="d-inline-block mb-3">CREATE EVENT</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name">Event_Name</label>
              <input
                type="text"
                className="form-control"
                id="name"
                required={true}
                placeholder="Enter name"
                value={event_name}
                onChange={(e) => setEvent_name(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Event_Image</label>
              <input
                type="text"
                className="form-control"
                id="name"
                required={true}
                placeholder="Enter image url"
                value={event_image}
                onChange={(e) => setEvent_image(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">event_date</label>
              <input
                type="date"
                className="form-control"
                id="name"
                required={true}
                placeholder="Enter date"
                value={event_date}
                onChange={(e) => setEvent_date(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Time</label>
              <input
                type="time"
                required={true}
                className="form-control"
                id="name"
                placeholder="Enter time"
                value={event_time}
                onChange={(e) => setEvent_time(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">event_location</label>
              <input
                type="text"
                required={true}
                className="form-control"
                id="name"
                placeholder="Enter location"
                value={event_location}
                onChange={(e) => setEvent_location(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">event_desc</label>
              <input
                type="text"
                required={true}
                className="form-control"
                id="name"
                placeholder="Enter description"
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

export default EventListEdit;
