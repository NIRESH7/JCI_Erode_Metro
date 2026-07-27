import React, { useEffect, useState } from "react";
import axios from "axios";
import {Link }from 'react-router-dom'
import "bootstrap/dist/css/bootstrap.min.css";
import srxc from "../assets/img/img.svg";
const EventList = (props) => {
  const [eventlist, setEventlist] = useState([]);
  const[render,setRender]=useState(true)
  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/member/allevents")
      .then((res) => {
        setEventlist(res.data.response.data.info);
      });
  }, [render]);
  function Update(id) {
    props.history.push("./SingleEvent?id=" + id);
  }
  function Updatee(id) {
    props.history.push("./Event_image_single?id=" + id);
  }
  function handledelete(id) {
    axios.post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/deleteEvent", {
      id: id,
    })
    .then((res)=> 
    {
     if(res.data.response.data.info == "Event Deleted")
      setRender(!render)
    })
  }
  return (
    <div className="container-fluid p-3">
      <table className="table table-sm mt-3">
        <thead className="thead-dark">
          <th>S.No</th>
          <th>Event Name</th>
          <th>Event image</th>
          <th>Event Date </th>
          <th>Event Time</th>
          <th> Location</th>
          <th>View</th>
          <th>View</th>
          <th>Edit</th>
          <th>Action</th>
        </thead>
        <tbody>
          {Array.isArray(eventlist) && eventlist.length !== 0 ? (
            eventlist.map((x, index) => (
              <tr>
                <td className="ml-3">{++index}</td>
                <td>{x.event_name}</td>
                <td>
                  <img
                    src={x.event_image}
                    onError={(e) => (e.currentTarget.src = srxc)}
                    width="50"
                    height="50"
                    alt={x.event_name}
                  />
                </td>
                <td>{x.event_date}</td>
                <td>{x.event_time}</td>
                <td>{x.event_location}</td>
                <td>
                  <a
                    style={{ cursor: "pointer" }}
                    onClick={() => Update(x.id)}
                    className="badge badge-success m-2"
                  >
                    View Event
                  </a>
                </td>
                <td>
                  <a
                    style={{ cursor: "pointer" }}
                    onClick={() => Updatee(x.id)}
                    className="badge badge-success m-2"
                  >
                    View Images
                  </a>
                </td>
                <td>
                  <Link to={"/admin/UpdateEvent/" + x.id}
                    style={{ cursor: "pointer" }}
                    className="badge badge-success m-2"
                  >
                    Edit
                  </Link>
                </td>
                <td>
                  <a
                    style={{ cursor: "pointer" }}
                    className="badge badge-danger m-2"
                    onClick={() => handledelete(x.id)  }
                  >
                    Delete Event
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
  );
};

export default EventList;
