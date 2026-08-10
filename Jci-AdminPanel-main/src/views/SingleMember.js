import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { BrowserRouter as Router, Link, useLocation } from "react-router-dom";
import { isJsxFragment } from "typescript";
import { toast } from "react-toastify";
import BackButton from "../components/BackButton";
function SingleMember(props) {
  function useQuery() {
    return new URLSearchParams(useLocation().search);
  }
  let query = useQuery();
  const [FamilyData, setFamilydata] = useState([]);
  const [member, setMember] = useState(null);
  const [family, setFamily] = useState(null);
  const [designation, setDesignation] = useState(null);
  const [rerender, setRerender] = useState(false);
  useEffect(() => {
    const id = query.get("id");
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getMember", { id })
      .then((res) => {
        setMember(res.data.response.data.info);
      });
  }, [rerender]);
  console.log(member);
  useEffect(() => {
    const id = query.get("id");
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/member/family", { id })
      .then((res) => {
        console.log("res", res);
        if (res.data.response.data.info !== null)
          setFamilydata(res.data.response.data.info);
        setFamily(res.data.response.data.info[0]);
      });
  }, [rerender]);
  console.log("dataFamily", FamilyData);

  useEffect(() => {
    const id = query.get("id");
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/member/designation", { id })
      .then((res) => {
        setDesignation(res.data.response.data.info[0]);
      });
  }, []);
  const Delete = (id) => {
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/deleteFamily", { id })
      .then((res) => {
        setRerender(!rerender);
        console.log("response", res);
      });
  };
  const active = (id) => {
    if (member.status === "active") {
      axios
        .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/changeStatus", {
          id: id,
          status: "inactive",
        })
        .then((res) => {
          toast.success("Member is now inactive");
          setRerender(!rerender);
          console.log("response", res);
        });
    } else {
      axios
        .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/changeStatus", {
          id: id,
          status: "active",
        })
        .then((res) => {
          toast.success("Member is now active");
          setRerender(!rerender);
          console.log("response", res);
        });
    }
  };

  const toggleAppAccess = (id) => {
    const next = member?.app_access === "full" ? "view" : "full";
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/changeAppAccess", {
        id,
        app_access: next,
      })
      .then(() => {
        toast.success(
          next === "full"
            ? "Member can now give referrals and post stories"
            : "Member is now view only"
        );
        setRerender(!rerender);
      })
      .catch(() => toast.error("Failed to update access"));
  };
  return (
    <>
      <div className="container-fluid p-3">
        <BackButton to="/admin/Memberlist" />
      </div>
      {" "}
      <div>
        <nav>
          <div className="nav nav-tabs" id="nav-tab" role="tablist">
            <button
              className="nav-link active"
              id="nav-home-tab"
              data-bs-toggle="tab"
              data-bs-target="#nav-home"
              type="button"
              role="tab"
              aria-controls="nav-home"
              aria-selected="true"
            >
              <span style={{ color: "black" }}> Members Profile</span>
            </button>
            <button
              className="nav-link"
              id="nav-profile-tab"
              data-bs-toggle="tab"
              data-bs-target="#nav-profile"
              type="button"
              role="tab"
              aria-controls="nav-profile"
              aria-selected="false"
            >
              <span style={{ color: "black" }}> Members Family</span>
            </button>
            <button
              className="nav-link"
              id="nav-contact-tab"
              data-bs-toggle="tab"
              data-bs-target="#nav-contact"
              type="button"
              role="tab"
              aria-controls="nav-contact"
              aria-selected="false"
            >
              <span style={{ color: "black" }}> JCI Members designation</span>
            </button>
          </div>
        </nav>
        <div className="tab-content" id="nav-tabContent">
          <div
            className="tab-pane fade show active"
            id="nav-home"
            role="tabpanel"
            aria-labelledby="nav-home-tab"
          >
            <ul className="list-group list-group-vertical">
              <li className="list-group-item"> Name :{member?.user_name}</li>

              <li className="list-group-item"> Email: {member?.email}</li>
              <li className="list-group-item"> Contact: {member?.contact}</li>
              <li className="list-group-item">Gender :{member?.gender}</li>
              <li className="list-group-item"> DOB : {member?.dob}</li>
              <li className="list-group-item"> Location :{member?.location}</li>
              <li className="list-group-item">
                {" "}
                Blood_group :{member?.blood_group}
              </li>
              <li className="list-group-item">
                {" "}
                Willing_to_donate :{member?.willing_to_donate}
              </li>
              <li className="list-group-item">
                {" "}
                Office_name :{member?.office_name}
              </li>
              <li className="list-group-item">job :{member?.job}</li>
              <li className="list-group-item"> Type :{member?.type}</li>
              <li className="list-group-item">
                {" "}
                marital_status :{member?.martial_status}
              </li>
              <li className="list-group-item"> Role :{member?.role}</li>
              <li className="list-group-item">
                {" "}
                App access :
                <a
                  style={{ cursor: "pointer", textTransform: "capitalize" }}
                  onClick={() => toggleAppAccess(member.id)}
                  className={
                    member?.app_access === "full"
                      ? "badge badge-success m-2"
                      : "badge badge-secondary m-2"
                  }
                >
                  {member?.app_access === "full" ? "Full access" : "View only"}
                </a>
                <small className="text-muted">(click to toggle)</small>
              </li>
              <li className="list-group-item">
                {" "}
                Status :
                {member?.status === "active" ? (
                  <a
                    style={{ cursor: "pointer", textTransform: "capitalize" }}
                    onClick={() => active(member.id)}
                    className="badge badge-success m-2"
                  >
                    Active
                  </a>
                ) : (
                  <a
                    style={{ cursor: "pointer", textTransform: "capitalize" }}
                    onClick={() => active(member.id)}
                    className="badge badge-danger m-2"
                  >
                    Inactive
                  </a>
                )}{" "}
              </li>
            </ul>
          </div>
          <div
            className="tab-pane fade"
            id="nav-profile"
            role="tabpanel"
            aria-labelledby="nav-profile-tab"
          >
            <table className="table table-sm mt-3">
              <thead className="thead-dark">
                <th>Family Name</th>
                <th> Relationship</th>
                <th>Dob </th>
                <th>Anniversary </th>
                <th>Status</th>
              </thead>
              <tbody>
                {Array.isArray(FamilyData) && FamilyData.length !== 0 ? (
                  FamilyData.map((x) => (
                    <tr>
                      <td>{x.name}</td>
                      <td>{x.relationship}</td>
                      <td>{x.dob}</td>
                      <td>{x.anniversary !== null ? x.anniversary : "-"}</td>

                      <td>
                        <a
                          style={{ cursor: "pointer" }}
                          onClick={() => Delete(x.id)}
                          className="badge badge-danger m-2"
                        >
                          Delete
                        </a>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    {" "}
                    <td className="text-center" colSpan="4">
                      <b>No data found to display.</b>
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
          {/* <ul className="list-group list-group-horizontal">
              <li className="list-group-item">  Family_Name :{family?.name}</li>
              <li className="list-group0-item"> Relationship :{family?.relationship}</li>
              <li className="list-group-item">Dob :{family?.dob}</li>
              <li className="list-group-item"> <a
                    style={{ cursor: "pointer" }}
                    onClick={() => Delete(family?.id)}
                    className="badge badge-danger m-2"
                  >
                     Delete
                  </a></li>
            </ul> */}
          <div
            className="tab-pane fade"
            id="nav-contact"
            role="tabpanel"
            aria-labelledby="nav-contact-tab"
          >
            <ul className="list-group list-group-vertical">
              <li className="list-group-item">
                Designation_Name :{designation?.designation_name}
              </li>
              <li className="list-group-item">
                Designation_Year :{designation?.designation_year}
              </li>
            </ul>
          </div>
        </div>
      </div>
    </>
  );
}
export default SingleMember;
