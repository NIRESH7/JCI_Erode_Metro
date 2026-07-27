import React, { useEffect, useState } from "react";
import {Link} from 'react-router-dom'
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import srxc from "../assets/img/propic.png"

function SponserList(props) {
  const [sponser, setSponser] = useState([]);
  const [render,setRender]=useState(true)

  useEffect(() => {
    axios.post(process.env.REACT_APP_URL_ADMIN+"/member/our_sponser", { role: "sponser",id :"" }).then((res) => {
      setSponser(res.data.response.data.info);
    });
  }, [render]);
  function Update(id) {
    props.history.push("./Singlesponserlist?id=" + id)
  }
  const Delete = (id) =>{
    axios.post(process.env.REACT_APP_URL_ADMIN+"/jciadmin/deleteSponser",{id:id})
    .then((res)=> 
    {
     if(res.data.response.data.info == "Sponsor deleted")
      setRender(!render)
    })
  }
  return (
    <div className="container-fluid p-3">
      <table className="table table-sm mt-3">
        <thead className="thead-dark">
          <th>Name</th>
          <th>Image</th>
          <th>Contact </th>
          <th>Email</th>
          <th>Location</th>
          <th>Action</th>
          <th>Edit</th>
          <th>Delete</th>
        </thead>
        <tbody>
          {Array.isArray(sponser) && sponser.length !==0  ? sponser?.map((x) => (
            <tr>
              <td style={{textTransform:"capitalize"}}>{x.sponser_name}</td>
              <td>
                <img src={x.sponser_image}  onError={(e)=>e.currentTarget.src=srxc} width="50" height="40" />
              </td>
              <td>{x.sponser_contact}</td>
              <td>{x.sponser_email}</td>
              <td style={{textTransform:"capitalize"}}>{x.sponser_location}</td>
              <td>
                <a style={{cursor:"pointer"}} onClick={() => Update(x.id)} className="badge badge-success m-2"> View </a>
              </td>
              <td>
                <Link to={"/admin/EditSponser/sponser/" + x.id} style={{cursor:"pointer"}}  className="badge badge-success m-2"> Edit </Link>
              </td>
              <td>
                <a style={{cursor:"pointer"}} onClick={() => Delete(x.id)} className="badge badge-danger m-2"> Delete </a>
              </td>
            </tr>
          )):   <tr>
          <td className="text-center" colSpan="4">
            <b>No data found to display.</b>
          </td>
        </tr> }
        
        </tbody>
      </table>
    </div>
  );
}

export default SponserList;
