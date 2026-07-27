import React, { useEffect, useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";

function EditEvent() {
  const [userList, setUserList] = useState([]);

  useEffect(() => {
    axios.get(process.env.REACT_APP_URL_ADMIN+"/member/allevents_image").then((res) => {
      setUserList(res.data.response.data.info);
    });
  }, []);

  return (
    <div className="container-fluid p-3">
      <table className="table table-sm mt-3">
        <thead className="thead-dark">
          <th>event_id </th>
          <th>Event status </th>
          <th>Event image </th>
        </thead>
        <tbody>
          {userList.map((x) => (
            <tr>
              <td>{x.event_id}</td>
              <td>{x.status}</td>

              <td>
                <img src={x.profile_pic} width="50" height="50" />
              </td>
            </tr>
          ))}
          {userList.length == 0 && (
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

export default EditEvent;
