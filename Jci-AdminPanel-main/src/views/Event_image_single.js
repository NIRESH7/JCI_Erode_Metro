import React, { useEffect, useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { BrowserRouter as Router, Link, useLocation } from "react-router-dom";
import srxc from "../assets/img/img.svg";
import BackButton from "../components/BackButton";

function Event_image_single(props) {
  const [eventimages, setEventimages] = useState([]);
  const [Id,EventImageID]=useState("");

  function useQuery() {
    return new URLSearchParams(useLocation().search);
  }
  let query = useQuery();
  const [rerender,setRerender]=useState(false)
  useEffect(() => {
    const id = query.get("id");
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/member/event_image", { id })
      .then((res) => {
        setEventimages(res.data.response.data.info);
        console.log("response",res);
      });
  }, [rerender]);
  const deleteImage=(id,status)=>{
      console.log("status",status);
    axios
    .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/deleteEventImage", { id,status })
    .then((res) => {
      setRerender(!rerender);
      console.log("response",res);
    });
  }
  return (
    <>
      <div className="container-fluid p-3">
        <BackButton to="/admin/EventList" />
      </div>
      {Array.isArray(eventimages) && eventimages.length !== 0
        ? eventimages.map((image) => (
            <div className="card" style={{width: "18rem"}}>
  <img src={image.event_image}
                 onError={(e) => (e.currentTarget.src = srxc)}
               className="card-img-top"
               alt=""/>
  <div className="card-body">
   
    <span  className="btn btn-primary" onClick={()=>deleteImage(image.id,(image.status==="active"?"inactive":"active"))}>{image.status==="inactive"? "Delete" :"Active"}</span>
  </div>
</div>

            // <div className="card" style={{ width: "20rem" }}>
            //  <i className='bx bxs-trash'  style={{fontSize: "40px",float: "right" }}></i>
            //   <img
            //     src={image.event_image}
            //     onError={(e) => (e.currentTarget.src = srcx)}
            //     className="card-img-top"
            //     alt=""
            //   />
            //   {/* <p>{image.id}</p> */}
            // </div>




          ))
        : "No Image Found"}
    </>
  );
}

export default Event_image_single;
