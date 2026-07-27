import React, { useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";

function Login() {
  const [sponser_name, setSponser_name] = useState("");
  const [sponser_image, setSponser_image] = useState("");
  const [sponser_contact, setSponser_contact] = useState("");
  const [sponser_email, setSponser_email] = useState("");
  const [sponser_description, setSponser_description] = useState("");
  const [sponser_location, setSponser_location] = useState("");
  const [sponser_website, setSponser_website] = useState("");
  const [role, setRole] = useState("");
  const [status, setStatus] = useState("");

  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);

  const handleSubmit = () => {
    setLoading(true);
    setIsError(false);
    const data = {
      sponser_name: sponser_name,
      sponser_image: sponser_image,
      sponser_contact: sponser_contact,
      sponser_email: sponser_email,
      sponser_description: sponser_description,
      sponser_location: sponser_location,
      sponser_website: sponser_website,
      role: role,
      status: status,
    };
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/createSponser", data)
      .then((res) => {
        setData(res.data);
        setSponser_name("");
        setSponser_image("");
        setSponser_contact("");
        setSponser_email("");
        setSponser_description("");
        setSponser_location("");
        setSponser_website("");
        setRole("");
        setStatus("");
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
      });
  };

  return (
    <div className="container p-3">
      <h5 className="d-inline-block mb-3">CREATE SPONSER</h5>
      <div style={{ maxWidth: 600 }}>
        <div className="form-group">
          <label htmlFor="name">sponser_name</label>
          <input
            type="text"
            className="form-control"
            id="name"
            placeholder="Enter name"
            value={sponser_name}
            onChange={(e) => setSponser_name(e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="name">sponser_image</label>
          <input
            type="text"
            className="form-control"
            id="name"
            placeholder="Enter image url"
            value={sponser_image}
            onChange={(e) => setSponser_image(e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="name">sponser_contact</label>
          <input
            type="number"
            className="form-control"
            id="name"
            placeholder="Enter number"
            value={sponser_contact}
            onChange={(e) => setSponser_contact(e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="name">sponser_email</label>
          <input
            type="email"
            className="form-control"
            id="name"
            placeholder="Enter email"
            value={sponser_email}
            onChange={(e) => setSponser_email(e.target.value)}
          />
        </div>

        <div className="form-group">
          <label htmlFor="name">sponser_description</label>
          <input
            type="text"
            className="form-control"
            id="name"
            placeholder="Enter description"
            value={sponser_description}
            onChange={(e) => setSponser_description(e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="name">sponser_location</label>
          <input
            type="text"
            className="form-control"
            id="name"
            placeholder="Enter location"
            value={sponser_location}
            onChange={(e) => setSponser_location(e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="name">sponser_website</label>
          <input
            type="text"
            className="form-control"
            id="name"
            placeholder="Enter website name"
            value={sponser_website}
            onChange={(e) => setSponser_website(e.target.value)}
          />
        </div>

        <div className="form-group">
          <label htmlFor="name">role</label>
          <input
            type="number"
            className="form-control"
            id="number"
            placeholder="Enter roll number"
            value={role}
            onChange={(e) => setRole(e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="name">status</label>
          <div className="input-group mb-3">
            <select
              value={status}
              onChange={(e) => setStatus(e.target.value)}
              className="form-select"
              id="inputGroupSelect01"
            >
              <option selected>Choose...</option>
              <option>active</option>
              <option>inactive</option>
            </select>
          </div>
        </div>

        {isError && (
          <small className="mt-3 d-inline-block text-danger">
            Something went wrong. Please try again later.
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
      </div>
    </div>
  );
}

export default Login;
