import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { useLocation } from "react-router-dom";
import { ToastContainer, toast } from "react-toastify";

function UpdateMember() {
  const [image, setImage] = useState();
  const [user_name, setUser_name] = useState("");
  const [email, setEmail] = useState("");
  const [contact, setContact] = useState("");
  const [gender, setGender] = useState("");
  const [dob, setDob] = useState("");
  const [location, setLocation] = useState("");
  const [blood_group, setBlood_group] = useState("");
  const [willing_to_donate, setWilling_to_donate] = useState("");
  const [office_name, setOffice_name] = useState("");
  const [sector, setSector] = useState({id:"",sector:""});

  const [job, setJob] = useState("");
  const [martial_status, setMartial_status] = useState("");
  const [role, setRole] = useState("");
  const [GetImage, SetGetImage] = useState("");

  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);
  const [roles, setRoles] = useState([]);
  const [userlist, setUserlist] = useState([]);
  function useQuery() {
    return new URLSearchParams(useLocation().search);
  }

  let query = useQuery();
  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getAllBusinessName")
      .then((res) => {
        setUserlist(res.data.response.data.info);
      });
  }, []);
  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getRoles")
      .then((res) => {
        setRoles(res.data.response.data.info);
      });

    const id = query.get("id");
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getMember", { id })
      .then((res) => {
        console.log("Data", res.data);
        // setImage(res.data.response.data.info)
        setUser_name(res.data.response.data.info.user_name);
        setContact(res.data.response.data.info.contact);
        setDob(res.data.response.data.info.dob.split("/").reverse().join("-"));
        console.log(
          "dob",
          res.data.response.data.info.dob.split("/").reverse().join("-")
        );
        setLocation(res.data.response.data.info.location);
        setBlood_group(res.data.response.data.info.blood_group);
        setWilling_to_donate(res.data.response.data.info.willing_to_donate);
        setOffice_name(res.data.response.data.info.office_name);
        setGender(res.data.response.data.info.gender);
        setEmail(res.data.response.data.info.email);
        setMartial_status(res.data.response.data.info.martial_status);
        setRole(res.data.response.data.info.role || "");
        setLocation(res.data.response.data.info.location);
        setSector(res.data.response.data.info.sector || "");
        setJob(res.data.response.data.info.job);
        SetGetImage(res.data.response.data.info.profile_pic);
        // console.log("Image",res.data.response.data.info.profile_pic);
      });
  }, []);

  console.log("rolels", roles);

  const handleSubmit = (e) => {
    e.preventDefault();
    const id = query.get("id");

    setLoading(true);
    setIsError(false);
    const data = {
      image: image,
      user_name: user_name,
      email: email,
      contact: contact,
      gender: gender,
      dob: dob,
      location: location,
      blood_group: blood_group,
      willing_to_donate: willing_to_donate,
      id,
      office_name: office_name,
      job: job,
      martial_status: martial_status,
      role: role,

      sector: typeof sector === "object" ? sector.sector || sector.value || "" : sector,
    };

    const formdata = new FormData();
    Object.entries(data).map((data) => {
      formdata.append(data[0], data[1]);
    });
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/updateMember",
        formdata
      )
      .then((res) => {
        setData(res.data);
        setImage("");
        setUser_name("");
        setEmail("");
        setContact("");
        setGender("");
        setDob("");
        setLocation("");
        setBlood_group("");
        setWilling_to_donate("");
        setOffice_name("");
        setSector("");
        setJob("");
        setMartial_status("");
        setRole("");
        toast.success("Member Updated successfully!");
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
        toast.error("Member Updation failed!");
        e.currentTarget.reset();
      });
  };

  return (
    <div className="container p-3">
      <h5 className="d-inline-block mb-3">UPDATE MEMBER</h5>
      <div style={{ maxWidth: 600 }}>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="name">Profile Picture</label>
            <div>
              <img src={GetImage} height="100px" alt="sample" />
            </div>
            <input
              type="file"
              className="form-control"
              files={[{ name: "hello.png" }]}
              id="image"
              // value={image}
              onChange={(e) => {
                console.log("Image", e.target.files);
                if (e.target.files) setImage(e.target.files[0]);
              }}
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
              type="text"
              className="form-control"
              id="name"
              placeholder="Enter Number"
              value={contact}
              minLength="10"
              maxLength="13"
              onChange={(e) => setContact(e.target.value)}
              required={false}
            />
          </div>
          <div className="form-group">
            <label htmlFor="name">Gender</label>
            <div className="input-group mb-3">
              <select
                value={gender}
                onChange={(e) => setGender(e.target.value)}
                className="form-select"
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
            <div className="input-group mb-3">
              <select
                value={willing_to_donate}
                onChange={(e) => setWilling_to_donate(e.target.value)}
                className="form-select"
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
            <label htmlFor="name">Office Name</label>
            <input
              type="text"
              className="form-control"
              id="name"
              placeholder="Enter Officename"
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
                    ?.id || ""; // Find the corresponding user id based on the selected Business_name
                setSector({ id: userId, value: e.target.value });
              }}
              className="form-select"
            >
              <option value="" disabled>
                Select Business Category
              </option>
              {userlist
                .filter((user) => user.parent_Id === 0)
                .map((user) => (
                  <option
                    style={{ textTransform: "capitalize" }}
                    value={sector}
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
            <label htmlFor="name">Business Name</label>
            <select
              onChange={(e) => setJob(e.target.value)}
              className="form-select"
            >
              <option value="" disabled>
                Select Designation
              </option>
              {userlist
                .filter((user) => sector === user.parent_Id)
                .map((user) => (
                  <option
                    style={{ textTransform: "capitalize" }}
                    value={job}
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
            <div className="input-group mb-3">
              <select
                value={martial_status}
                onChange={(e) => setMartial_status(e.target.value)}
                required={false}
                className="form-select"
                id="inputGroupSelect01"
              >
                <option selected>Choose...</option>
                <option value="married">Married</option>
                <option value="not married">UnMarried</option>
              </select>
            </div>
          </div>

          {/* <div className="form-group">
          <label htmlFor="name">Role Number</label>
          <input
            type="number"
            className="form-control"
            id="name"
            placeholder="Enter role number"
            value={role}
            onChange={(e) => setRole(e.target.value)}
            required={true}
          />
        </div> */}
          {/* <div className="form-group">
          <label htmlFor="name">Role</label>
          <div className="input-group mb-3">
            <select
              value={role}
              onChange={(e) => setRole(e.target.value)}
              className="form-select"
            >
              <option selected>Role</option>
              <option value="member">Member</option>
              <option value="president">President</option>
            </select>
          </div>
        </div> */}

          <div className="form-group">
            <label htmlFor="name">Role</label>
            <div className="input-group mb-3">
              <select
                value={role}
                required={false}
                onChange={(e) => setRole(e.target.value)}
                className="form-select"
              >
                <option value="">select</option>
                {roles.map((user) => (
                  <option
                    style={{ textTransform: "capitalize" }}
                    value={user.role_name}
                  >
                    {user.role_name}
                  </option>
                ))}
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
            onClick={handleSubmit}
            disabled={loading}
          >
            {loading ? "Loading..." : "Submit"}
          </button>
        </form>
      </div>
    </div>
  );
}

export default UpdateMember;
