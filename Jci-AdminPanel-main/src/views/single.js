import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { BrowserRouter as Router, Link, useLocation } from "react-router-dom";

function Update(props) {
  function useQuery() {
    return new URLSearchParams(useLocation().search);
  }
  let query = useQuery();
  const [profile_pic, setProfile_pic] = useState("");
  const [user_name, setUser_name] = useState("");
  const [email, setEmail] = useState("");
  const [contact, setContact] = useState("");
  const [gender, setGender] = useState("");
  const [dob, setDob] = useState("");
  const [location, setLocation] = useState("");
  const [blood_group, setBlood_group] = useState("");
  const [willing_to_donate, setWilling_to_donate] = useState("");
  const [office_name, setOffice_name] = useState("");
  const [job, setJob] = useState("");
  const [martial_status, setMartial_status] = useState("");
  const [role, setRole] = useState("");
  const [status, setStatus] = useState("");
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);

  useEffect(() => {
    const id = query.get("id");
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/member/member", { id })
      .then((res) => {
        setData(res.data.response.data.info[0]);
      });
  }, []);

  const handleSubmit = () => {
    setLoading(true);
    setIsError(false);
    const data = {
      profile_pic: profile_pic,
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
      role: role,
      status: status,
    };

    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/member/allmember", data)
      .then((res) => {
        setData(res.data);
        setProfile_pic("");
        setUser_name("");
        setEmail("");
        setContact("");
        setGender("");
        setDob("");
        setLocation("");
        setBlood_group("");
        setWilling_to_donate("");
        setOffice_name("");
        setJob("");
        setMartial_status("");
        setRole("");
        setStatus("");
        setLoading(false);
      })
      .catch((err) => {
        setLoading(false);
        setIsError(true);
      });
  };

  return (
    <div>
      <div className="form-group">
        <label htmlFor="name">Profile_Pic</label>
        <input
          type="text"
          className="form-control"
          id="name"
          placeholder={data?.profile_pic}
          value={data?.profile_pic}
          onChange={(e) => setProfile_pic(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">Username</label>
        <input
          type="text"
          className="form-control"
          id="name"
          placeholder="user_name"
          value={data?.user_name}
          onChange={(e) => setUser_name(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">Email</label>
        <input
          type="email"
          className="form-control"
          id="name"
          placeholder="Enter email"
          value={data?.email}
          onChange={(e) => setEmail(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">contact</label>
        <input
          type="text"
          className="form-control"
          id="name"
          placeholder="Enter number"
          value={data?.contact}
          onChange={(e) => setContact(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">Gender</label>
        <div className="input-group mb-3">
          <select
            value={data?.gender}
            onChange={(e) => setGender(e.target.value)}
            className="form-select"
            id="inputGroupSelect01"
          >
            <option selected>Choose...</option>
            <option>Male</option>
            <option>Female</option>
          </select>
        </div>
      </div>

      <div className="form-group">
        <label htmlFor="name">dob</label>
        <input
          type="date"
          format="mm.dd.yyyy"
          className="form-control"
          id="name"
          placeholder="Enter date of birth"
          value={data?.dob}
          onChange={(e) => setDob(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">location</label>
        <input
          type="text"
          className="form-control"
          id="name"
          placeholder="Enter location"
          value={data?.location}
          onChange={(e) => setLocation(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">blood_group</label>
        <input
          type="text"
          className="form-control"
          id="name"
          placeholder="Enter bloodgroup"
          value={data?.blood_group}
          onChange={(e) => setBlood_group(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">willing to Donate</label>
        <div className="input-group mb-3">
          <select
            value={data?.willing_to_donate}
            onChange={(e) => setWilling_to_donate(e.target.value)}
            className="form-select"
            id="inputGroupSelect01"
          >
            <option selected>Choose...</option>
            <option>yes</option>
            <option>No</option>
          </select>
        </div>
      </div>
      <div className="form-group">
        <label htmlFor="name">office_name</label>
        <input
          type="text"
          className="form-control"
          id="name"
          placeholder="Enter officename"
          value={data?.office_name}
          onChange={(e) => setOffice_name(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">job</label>
        <input
          type="text"
          className="form-control"
          id="name"
          placeholder="Enter job"
          value={data?.job}
          onChange={(e) => setJob(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">Marital Status</label>
        <div className="input-group mb-3">
          <select
            value={data?.martial_status}
            onChange={(e) => setMartial_status(e.target.value)}
            className="form-select"
            id="inputGroupSelect01"
          >
            <option selected>Choose...</option>
            <option>Married</option>
            <option>UnMarried</option>
          </select>
        </div>
      </div>

      <div className="form-group">
        <label htmlFor="name">role</label>
        <input
          type="number"
          className="form-control"
          id="name"
          placeholder="Enter role number"
          value={data?.role}
          onChange={(e) => setRole(e.target.value)}
        />
      </div>
      <div className="form-group">
        <label htmlFor="name">status</label>
        <div className="input-group mb-3">
          <select
            value={data?.status}
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
  );
}

export default Update;
