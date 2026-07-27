import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";

function CreateMember() {
  const [image, setImage] = useState("");
  const [user_name, setUser_name] = useState("");
  const [jci_location, setJci_location] = useState("");
  const [member_id, setMember_id] = useState("");
  const [email, setEmail] = useState("");
  const [contact, setContact] = useState("");
  const [gender, setGender] = useState("");
  const [dob, setDob] = useState("");
  const [location, setLocation] = useState("");
  const [blood_group, setBlood_group] = useState("");
  const [willing_to_donate, setWilling_to_donate] = useState("");
  const [office_name, setOffice_name] = useState("");
  const [sectors, setSectors] = useState({ id: "", sector: "" });
  console.log(sectors.value);
  const [job, setJob] = useState("");
  const [martial_status, setMartial_status] = useState("");
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);
  const [userlist, setUserlist] = useState([]);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getAllBusinessName")
      .then((res) => {
        setUserlist(res.data.response.data.info);
      });
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();
    e.currentTarget.reset();
    setLoading(true);
    setIsError(false);
    const data = {
      image: image,
      member_id: member_id,
      jci_location: jci_location,
      user_name: user_name,
      email: email,
      contact: contact,
      gender: gender,
      dob: dob,
      location: location,
      blood_group: blood_group,
      willing_to_donate: willing_to_donate,
      office_name: office_name,
      job: job,
      martial_status: martial_status,
      sector: sectors.value,
    };
    const formdata = new FormData();
    Object.entries(data).map((data) => {
      formdata.append(data[0], data[1]);
    });
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/createMember",
        formdata
      )
      .then((res) => {
        setData(res.data);
        setImage("");
        setUser_name("");
        setMember_id("");
        setJci_location("");
        setEmail("");
        setContact("");
        setGender("");
        setDob("");
        setLocation("");
        setBlood_group("");
        setWilling_to_donate("");
        setOffice_name("");
        setSectors("");
        setJob("");
        setMartial_status("");
        toast.success("Member created successfully!");
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
        toast.error("Member creation failed!");
      });
  };

  return (
    <div className="container p-3 m-5 ">
      <h5 className="d-inline-block mb-3">CREATE MEMBER</h5>
      <div style={{ maxWidth: 600 }}>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="name">Profile Picture</label>
            <input
              type="file"
              className="form-control"
              id="image"
              // value={image}
              onChange={(e) => {
                if (e.target.files) setImage(e.target.files[0]);
              }}
              required={false}
            />
          </div>
          <div className="form-group">
            <label htmlFor="name">Username</label>
            <input
              type="text"
              className="form-control"
              id="name"
              placeholder="user_name"
              value={user_name}
              onChange={(e) => setUser_name(e.target.value)}
              required={false}
            />
          </div>{" "}
          <div className="form-group">
            <label htmlFor="name">Membership ID</label>
            <input
              type="text"
              className="form-control"
              id="member_id"
              placeholder="membership_id"
              value={member_id}
              onChange={(e) => setMember_id(e.target.value)}
              required={false}
            />
          </div>
          <div className="form-group">
            <label htmlFor="name">Email</label>
            <input
              type="email"
              className="form-control"
              id="name"
              placeholder="Enter Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required={false}
            />
          </div>
          <div className="form-group">
            <label htmlFor="name">Contact</label>
            <input
              type="number"
              className="form-control"
              id="name"
              placeholder="Enter Number"
              value={contact}
              minLength="10"
              maxLength="10"
              onChange={(e) => {
                if (String(e.target.value).length < 11)
                  setContact(e.target.value);
              }}
              required={false}
            />
          </div>
          <div className="form-group">
            <label htmlFor="name">Gender</label>
            <div class="input-group mb-3">
              <select
                value={gender}
                onChange={(e) => setGender(e.target.value)}
                class="form-select"
                id="inputGroupSelect01"
              >
                <option selected>Choose...</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="others">Transgender</option>
              </select>
            </div>
          </div>
          <div className="form-group">
            <label htmlFor="name">DOB</label>
            <input
              type="date"
              format="dd/mm/yyyy"
              className="form-control"
              id="name"
              placeholder="Enter Date of Birth"
              required={false}
              value={dob}
              onChange={(e) => setDob(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label htmlFor="name">Communication Address</label>
            <textarea
              className="form-control"
              id="name"
              placeholder="Enter Communication Address"
              value={location}
              onChange={(e) => setLocation(e.target.value)}
              required={false}
            />
          </div>
          <div className="form-group">
            <label htmlFor="name">Blood Group</label>
            <select
              value={blood_group}
              required={false}
              onChange={(e) => setBlood_group(e.target.value)}
              class="form-select"
            >
              <option selected>Blood Group</option>
              <option value="O+">O+</option>
              <option value="O-">O-</option>
              <option value="A+">A+</option>
              <option value="A-">A-</option>
              <option value="B+">B+</option>
              <option value="B-">B-</option>
              <option value="AB+">AB+</option>
              <option value="AB-">AB-</option>
              <option value="A1+">A1+</option>
              <option value="A1+">A1B+</option>
              <option value="A1+">A1B-</option>
              <option value="A1+">A2B+</option>
              <option value="A2+">A2+</option>
              <option value="HH">HH</option>
            </select>
            {/* <input
            type="text"
            className="form-control"
            id="name"
            placeholder="Enter Bloodgroup"
            value={blood_group}
            onChange={(e) => setBlood_group(e.target.value)}
            required={true}
          /> */}
          </div>
          <div className="form-group">
            <label htmlFor="name">Willing to Donate</label>
            <div class="input-group mb-3">
              <select
                value={willing_to_donate}
                onChange={(e) => setWilling_to_donate(e.target.value)}
                class="form-select"
                required={false}
                id="inputGroupSelect01"
              >
                <option selected>Choose...</option>
                <option value="yes">Yes</option>
                <option value="no">No</option>
              </select>
            </div>
          </div>
          <div className="form-group">
            <label htmlFor="name">Company Name</label>
            <input
              type="text"
              className="form-control"
              id="name"
              placeholder="Enter Company Name"
              required={false}
              value={office_name}
              onChange={(e) => setOffice_name(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label htmlFor="name">Business Category</label>
            <select
              onChange={(e) => {
                const userId =
                  userlist.find((u) => u.Business_name === e.target.value)
                    ?.id || "";
                setSectors({ id: userId, value: e.target.value });
              }}
              className="form-select"
            >
              <option value="">Select Business Category</option>
              {userlist
                .filter((user) => user.parent_Id === 0)
                .map((user) => (
                  <option
                    style={{ textTransform: "capitalize" }}
                    value={user.Business_name}
                    key={user.id}
                  >
                    {user.Business_name.toLowerCase().replace(/\b\w/g, (char) =>
                      char.toUpperCase()
                    )}
                  </option>
                ))}
            </select>
          </div>
          <div className="form-group">
            <label htmlFor="name">Designation</label>
            <select
              onChange={(e) => setJob(e.target.value)}
              className="form-select"
            >
              <option value="">Select Designation</option>
              {userlist
                .filter((user) => user.parent_Id === sectors.id)
                .map((user) => (
                  <option
                    style={{ textTransform: "capitalize" }}
                    value={user.Business_name}
                    key={user.id}
                  >
                    {user.Business_name.toLowerCase().replace(/\b\w/g, (char) =>
                      char.toUpperCase()
                    )}
                  </option>
                ))}
            </select>
          </div>
          <div className="form-group">
            <label htmlFor="name">Marital Status</label>
            <div class="input-group mb-3">
              <select
                value={martial_status}
                onChange={(e) => setMartial_status(e.target.value)}
                required={false}
                class="form-select"
                id="inputGroupSelect01"
              >
                <option selected>Choose...</option>
                <option value="married">Married</option>
                <option value="unmarried">UnMarried</option>
              </select>
            </div>
          </div>
          <div className="form-group">
            <label htmlFor="name">JCI location</label>
            <div class="input-group mb-3">
              <select
                value={jci_location}
                onChange={(e) => setJci_location(e.target.value)}
                class="form-select"
                required={false}
                id="inputGroupSelect01"
              >
                <option selected>Choose...</option>
                <option value="erode">erode</option>
                <option value="Modakurichi">Modakurichi</option>
              </select>
            </div>
          </div>
          {/* <div className="form-group">
          <label htmlFor="name">Status</label>
          <div class="input-group mb-3">
            <select
              value={status}
              onChange={(e) => setStatus(e.target.value)}
              class="form-select"
              id="inputGroupSelect01"
              required={true}
            >
              <option selected>Choose...</option>
              <option value="active">active</option>
              <option value="inactive">inactive</option>
            </select>
          </div>
        </div> */}
          <ToastContainer />
          {isError && (
            <small className="mt-3 d-inline-block text-danger">
              Something went wrong. Please try again later.
            </small>
          )}
          <button
            type="submit"
            className="btn btn-primary mt-3"
            // onClick={handleSubmit}
            disabled={loading}
          >
            {loading ? "Loading..." : "Submit"}
          </button>
        </form>
      </div>
    </div>
  );
}

export default CreateMember;
