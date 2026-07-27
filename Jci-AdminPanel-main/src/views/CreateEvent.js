import React, { useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";
function CreateEvent() {
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
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/createEvent", formdata)
      .then((res) => {
        setData(res.data);
        setEvent_name("");
        setImage("");
        setEvent_date("");
        setEvent_time("");
        setEvent_location("");
        setEvent_desc("");
        toast.success("Event Created Successfully!");
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
    console.log(file.size);
    if (file.size > size) {
      err = file.type + "is too large, please pick a smaller file\n";
      //  toast.error(err);
    }
  };
  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3">
          <h5 className="d-inline-block mb-3">CREATE EVENT</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name">Event Name</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter Name"
                value={event_name}
                required={false}
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
                  if (validateSize(e)) console.log(file);
                }}
                required={false}
              />
              <span style={{ color: "Red" }}>Max size 5mb</span>
            </div>

            <div className="form-group">
              <label htmlFor="name">Event Date</label>
              <input
                type="date"
                format="dd/mm/yyyy"
                className="form-control"
                id="name"
                placeholder="Enter Date"
                value={event_date}
                required={false}
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
                required={false}
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
                required={false}
                onChange={(e) => setEvent_location(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Event Description</label>
              <textarea
                className="form-control"
                id="name"
                required={false}
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

export default CreateEvent;
