import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";

function CreateFamily() {
  const [name, setName] = useState("");
  const [membername, setmemberName] = useState("");
  const [dob, setDob] = useState("");
  const [relationship, setRelationship] = useState("");
  const [blood_group, setBlood_group] = useState("");
  const [anniversary, setAnniversary] = useState("");
  const [member_id, setMember_id] = useState("");
  const [userlist, setUserlist] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);
  console.log(data);

  const temp = null;
  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/member/allmembers")
      .then((res) => {
        setUserlist(res.data.response.data.info);
      });
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!member_id) {
      toast.error("Please select a member");
      return;
    }
    if (!name.trim()) {
      toast.error("Please enter family member name");
      return;
    }
    setLoading(true);
    setIsError(false);
    const data = {
      member_id: member_id,
      name: name,
      blood_group: blood_group,
      dob: dob,
      relationship: relationship,
      anniversary: anniversary === "" ? null : anniversary,
    };
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/createFamily", data)
      .then((res) => {
        if (res.data.response.data.info === "Spouse already added") {
          toast.error("Spouse already added!");
          setLoading(false);
        } else {
          setData(res.data);
          setMember_id("");
          setName("");
          setBlood_group("");
          setDob("");
          setRelationship("");
          setAnniversary("");
          toast.success("Family created successfully!");
          setLoading(false);
        }
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
        toast.error("Family creation failed!");
      });
  };
  console.log(data);
  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3">
          <h5 className="d-inline-block mb-3">CREATE FAMILY</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name">Member Name</label>
              <div className="input-group mb-3">
                <select
                  required={false}
                  onChange={(e) => {
                    setMember_id(userlist[e.target.value].id);
                    setmemberName(userlist[e.target.value].user_name);
                  }}
                  className="form-select"
                >
                  {" "}
                  <option value="">Choose</option>
                  {userlist.map((user, index) => (
                    <option
                      style={{ textTransform: "capitalize" }}
                      value={index}
                    >
                      {user.user_name}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="name">Name</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required={false}
              />
            </div>

            <div className="form-group">
              <label htmlFor="name">Blood Group</label>
              <select
                value={blood_group}
                required={false}
                onChange={(e) => setBlood_group(e.target.value)}
                className="form-select"
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
              <label htmlFor="name">Relationship</label>
              <div className="input-group mb-3">
                <select
                  value={relationship}
                  required={false}
                  onChange={(e) => setRelationship(e.target.value)}
                  className="form-select"
                >
                  <option selected>Relationship</option>
                  <option value="Sister">Sister</option>
                  <option value="Brother">Brother</option>
                  <option value="Cousin">Cousin</option>
                  <option value="Friend">Friend</option>
                  <option value="Father">Father</option>
                  <option value="Mother">Mother</option>
                  <option value="Spouse">Spouse</option>
                  <option value="Childeren">Childeren</option>
                  <option value="siblings">siblings</option>
                </select>
              </div>
              {relationship === "Spouse" ? (
                <div className="form-group">
                  <label htmlFor="name">Anniversary Year</label>
                  <input
                    type="date"
                    format="dd/mm/yyyy"
                    className="form-control"
                    id="anniversary"
                    placeholder="Enter Anniversary Year"
                    value={anniversary}
                    onChange={(e) => setAnniversary(e.target.value)}
                    required={false}
                  />
                </div>
              ) : (
                ""
              )}
            </div>

            <div className="form-group">
              <label htmlFor="name">DOB</label>
              <input
                type="date"
                format="dd/mm/yyyy"
                className="form-control"
                id="name"
                required={false}
                placeholder="Enter image url"
                value={dob}
                onChange={(e) => setDob(e.target.value)}
              />
            </div>

            {/* <div className="form-group">
                    <label htmlFor="name">Relationship</label>
                    <input
                        type="text"
                        className="form-control"
                        id="name"
                      
                        value={relationship}
                        required={true}
                    />
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
export default CreateFamily;
