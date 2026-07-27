import React, { useState, useEffect } from "react";
import axios from "axios";

function Rolelist({ refreshKey = 0 }) {
  const [userList, setUserList] = useState([]);
  const [rerender, setRerender] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getRoles")
      .then((res) => {
        setUserList(res.data.response.data.info || []);
      })
      .catch(() => setUserList([]))
      .finally(() => setLoading(false));
  }, [rerender, refreshKey]);

  const Delete = (role) => {
    axios
      .post(process.env.REACT_APP_URL_ADMIN + "/jciadmin/deleteRoles", { role })
      .then(() => {
        setRerender((v) => !v);
      });
  };

  return (
    <div className="container-fluid p-3">
      {loading ? (
        <p className="text-muted">Loading roles...</p>
      ) : (
        <table className="table table-sm mt-3">
          <thead className="thead-dark">
            <tr>
              <th>S.No</th>
              <th>Role</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {Array.isArray(userList) && userList.length !== 0 ? (
              userList.map((x, index) => (
                <tr key={x.id || x.role_name || index}>
                  <td>{index + 1}</td>
                  <td>{x.role_name}</td>
                  <td>
                    <button
                      type="button"
                      onClick={() => Delete(x.role_name)}
                      className="badge badge-danger m-2 border-0"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td className="text-center" colSpan="3">
                  <b>No data found to display</b>
                </td>
              </tr>
            )}
          </tbody>
        </table>
      )}
    </div>
  );
}

export default Rolelist;
