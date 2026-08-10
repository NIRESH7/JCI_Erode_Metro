import React, { useEffect, useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";
import { useParams } from "react-router";
import BackButton from "../components/BackButton";

function EditSponser() {
  const { id, roles } = useParams();

  const [sponser, setSponser] = useState([]);
  const [sponser_name, setSponser_name] = useState("");
  const [image, setImage] = useState("");
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

  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      id: id,
      sponser_name: sponser_name,
      image: image,
      sponser_contact: sponser_contact,
      sponser_email: sponser_email,
      sponser_description: sponser_description,
      sponser_location: sponser_location,
      sponser_website: sponser_website,
      role: role,
      status: status,
    };
    const formdata = new FormData();
    Object.entries(data).map((data) => {
      formdata.append(data[0], data[1]);
    });
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/editSponser", formdata)
      .then((res) => {
        setData(res.data);
        setSponser_name("");
        setImage("");
        setSponser_contact("");
        setSponser_email("");
        setSponser_description("");
        setSponser_location("");
        setSponser_website("");
        setRole("");
        setStatus("");
        toast.success("Sponser Updated Successfully!");
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
        toast.error("Sponser creation failed!");
      });
  };
  useEffect(() => {
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN +
          "/member/" +
          (roles === "main_sponser" ? "main_sponser" : "our_sponser"),
        { role: roles, id: "" }
      )
      .then((res) => {
        res.data.response.data.info
          .filter((e) => id == e.id)
          .map((data) => {
            setSponser_name(data.sponser_name);
            setImage("");
            setSponser_contact(data.sponser_contact);
            setSponser_email(data.sponser_email);
            setSponser_description(data.sponser_description);
            setSponser_location(data.sponser_location);
            setSponser_website(data.sponser_website);
            setRole(data.role);
          });
      });
  }, []);

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3">
          <BackButton to={roles === "main_sponser" ? "/admin/Mainsponser" : "/admin/SponserList"} />
          <h5 className="d-inline-block mb-3">UPDATE SPONSER</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name">Sponser Name</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter name"
                value={sponser_name}
                onChange={(e) => setSponser_name(e.target.value)}
                required={true}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Sponser Image</label>
              <input
                type="file"
                className="form-control"
                id="name"
                onChange={(e) => {
                  if (e.target.files) setImage(e.target.files[0]);
                }}
                required={true}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Sponser Contact</label>
              <input
                type="number"
                className="form-control"
                id="name"
                placeholder="Enter number"
                value={sponser_contact}
                onChange={(e) => {
                  if (String(e.target.value).length < 11)
                    setSponser_contact(e.target.value);
                }}
                required={true}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Sponser Email</label>
              <input
                type="email"
                className="form-control"
                id="name"
                placeholder="Enter email"
                value={sponser_email}
                onChange={(e) => setSponser_email(e.target.value)}
                required={true}
              />
            </div>

            <div className="form-group">
              <label htmlFor="name">Sponser Description</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter description"
                value={sponser_description}
                onChange={(e) => setSponser_description(e.target.value)}
                required={true}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Sponser Location</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter location"
                value={sponser_location}
                onChange={(e) => setSponser_location(e.target.value)}
                required={true}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Sponser Website</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter website name"
                value={sponser_website}
                onChange={(e) => setSponser_website(e.target.value)}
                required={true}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Sponser</label>
              <div className="input-group mb-3">
                <select
                  value={role}
                  onChange={(e) => setRole(e.target.value)}
                  className="form-select"
                  aria-label="Default select example"
                >
                  <option selected>Choose</option>
                  <option value="sponser">Sponser</option>
                  <option value="main_sponser">Mainsponser</option>
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
        </div>
      </form>
    </div>
  );
}

export default EditSponser;
