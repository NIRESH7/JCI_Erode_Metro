import React, { useEffect, useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import srxc from "../assets/img/propic.png"
import {Link} from 'react-router-dom'


function Mainsponser(props) {
  const [sponser, setSponser] = useState([]);
  const [render,setRender]=useState(true)

  useEffect(() => {
    axios.post(process.env.REACT_APP_URL_ADMIN+"/member/main_sponser", { role: "main_sponser",id:"" }).then((res) => {
      setSponser(res.data.response.data.info);
    });
  }, [render]);
  function Update(id) {
    props.history.push("./Mainsponsersinle?id=" + id)
  }
  const Delete = (id) =>  {
    axios.post(process.env.REACT_APP_URL_ADMIN+"/jciadmin/deleteSponser", { id:id })
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
          <th>S No</th>
          <th>Name</th>
          <th>Image</th>
          <th>Contact </th>
          <th>Email</th>
          <th>Location</th>
          <th>Action</th>
          <th>Edit</th>
          <th>Action</th>
        </thead>
        <tbody>
          {Array.isArray(sponser) && sponser.length !== 0 ?sponser.map((x,i) => (
            <tr>
              <td >{++i}</td>
              <td style={{textTransform:"capitalize"}}>{x.sponser_name}</td>
              <td>
                <img src={x.sponser_image}  onError={(e)=>e.currentTarget.src=srxc} width="50" height="40" />
              </td>
              <td>{x.sponser_contact}</td>
              <td>{x.sponser_email}</td>
              <td style={{textTransform:"capitalize"}}>{x.sponser_location}</td>
              <td>
                <a onClick={() => Update(x.id)} className="badge badge-success m-2" style={{cursor:"pointer"}}><i className='bx bx-user-check'> </i> view </a>
              </td>
              <td>
                <Link to={"/admin/EditSponser/main_sponser/" + x.id}  className="badge badge-success m-2" style={{cursor:"pointer"}}>Edit </Link>
              </td>
              <td>
                <a onClick={() => Delete(x.id)} className="badge badge-danger m-2" style={{cursor:"pointer"}}><i className='bx bx-user-check' > </i> Delete </a>
              </td>
            </tr>
          )): <tr>
          <td className="text-center" colSpan="4">
            <b>No data found to display.</b>
          </td>
        </tr>}
        </tbody>
      </table>     
    </div>
  );
}

export default Mainsponser;
