import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import moment from "moment";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import srxc from "../assets/img/propic.png";

function DonorList(props) {
  const [donor, setDonor] = useState([]);
  const [render, setRender] = useState(true);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/listRequest")
      .then((res) => {
        setDonor(res.data.response.data.info);
      });
  }, [render]);
  const Verify = (id, val) => {
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/verifyBloodRequest", {
        status: val === "active" ? "inactive" : "active",
        id: id,
      })
      .then((res) => {
        axios
          .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/listRequest")
          .then((res) => {
            setDonor(res.data.response.data.info);
          });
        setRender(!render);
      });
  };
  return (
    <div className="container-fluid p-3">
      <table className="table table-sm mt-3">
        <thead className="thead-dark">
          <th>S.No</th>
          <th>Name of Patient</th>
          <th>Blood Group</th>
          <th>No of Units </th>
          <th>Hospital Name</th>
          <th>Location</th>
          <th>Contact</th>
          <th>Attender</th>
          <th>Date</th>
          <th>Created By</th>
          {/* <th>Delete</th> */}
        </thead>
        <tbody>
          {Array.isArray(donor) && donor.length !== 0 ? (
            donor?.map((x, index) => (
              <tr>
                <td className="ml-3">{++index}</td>
                <td style={{ textTransform: "capitalize" }}>
                  {x.NameOfPatient}
                </td>
                <td style={{ textTransform: "capitalize" }}>{x.BloodGroup} </td>
                <td>{x.NoOfUnits}</td>
                <td style={{ textTransform: "capitalize" }}>
                  {x.Hospital_name}
                </td>
                <td style={{ textTransform: "capitalize" }}>{x.location}</td>
                <td style={{ textTransform: "capitalize" }}>{x.Contact}</td>
                <td style={{ textTransform: "capitalize" }}>{x.Attender}</td>

                <td style={{ textTransform: "capitalize" }}>{x.createdAt}</td>
                <td style={{ textTransform: "capitalize" }}>{x.created_by}</td>
              </tr>
            ))
          ) : (
            <tr>
              <td className="text-center" colSpan="4">
                <b>No data found to display.</b>
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}

export default DonorList;
