import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";
function CreateFolder() {
  const [title, setTitle] = useState("");
  const [folderName, setFolderName] = useState("");
  const [image, setImage] = useState("");
  const [description, setDescription] = useState("");

  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);
  const [folder, setFolder] = useState(null);

  const [render, setRender] = useState(true);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getAllFolder")
      .then((res) => {
        setFolder(res.data.response.data.info);
      });
  }, [render]);
  const handleSubmit = (e) => {
    e.currentTarget.reset();
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    const data = {
      folderName: folderName,
      title: title,
      image: image,
      description: description,
    };
    const formdata = new FormData();
    Object.entries(data).map((data) => {
      data;
      formdata.append(data[0], data[1]);
    });
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/createFolder",
        formdata
      )
      .then((res) => {
        setData(res.data);
        setTitle("");
        setImage("");
        setDescription("");
        setFolderName("");
        toast.success("Folder Created Successfully!");
        axios
          .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getAllFolder")
          .then((res) => {
            setFolder(res.data.response.data.info);
          });
        setLoading(false);
      })
      .catch((err) => {
        console.log("Response", err.response);
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
        toast.error("Folder Creation failed!");
      });
  };

  const validateSize = (event) => {
    let file = event.target.files[0];
    let size = 50000;
    let err = "";
    console.log(file.size);
    if (file.size > size) {
      err = file.type + "is too large, please pick a smaller file\n";
      //  toast.error(err);
    }
  };
  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="container p-3">
          <h5 className="d-inline-block mb-3">CREATE Folder</h5>
          <div style={{ maxWidth: 600 }}>
            <div className="form-group">
              <label htmlFor="name">Folder Name</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter Folder Name"
                value={folderName}
                required={false}
                onChange={(e) => setFolderName(e.target.value)}
              />
            </div>
            <div className="form-group">
              <label htmlFor="name">Title</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter title"
                value={title}
                required={false}
                onChange={(e) => setTitle(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label htmlFor="name">Description</label>
              <input
                type="text"
                className="form-control"
                id="name"
                placeholder="Enter Name"
                value={description}
                required={false}
                onChange={(e) => setDescription(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label htmlFor="name">Folder Image</label>
              <input
                type="file"
                className="form-control"
                id="image"
                onChange={(e) => {
                  if (e.target.files) setImage(e.target.files[0]);
                  if (validateSize(e)) console.log(file);
                }}
                required={false}
              />
              <span style={{ color: "Red" }}>Max size 5mb</span>
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
              disabled={loading}
            >
              {loading ? "Loading..." : "Submit"}
            </button>
          </div>
        </div>
      </form>{" "}
      <div className="container-fluid p-3">
        <table className="table table-sm mt-3">
          <thead className="thead-dark">
            <th>S.No</th>
            <th>Folder Name</th>
            <th>Title</th>
            <th>Description</th>

            <th>Image</th>
            {/* <th>Delete</th> */}
          </thead>
          <tbody>
            {Array.isArray(folder) && folder.length !== 0 ? (
              folder?.map((x, index) => (
                <tr>
                  <td className="ml-3">{++index}</td>
                  <td style={{ textTransform: "capitalize" }}>
                    {x.folderName}
                  </td>
                  <td style={{ textTransform: "capitalize" }}>{x.title}</td>
                  <td style={{ textTransform: "capitalize" }}>
                    {x.description}
                  </td>{" "}
                  <td>
                    <img
                      src={x.image}
                      onError={(e) => (e.currentTarget.src = srxc)}
                      width="50"
                      height="50"
                    />
                  </td>
                  {/* <td style={{textTransform:"capitalize"}}>{x.status}</td> */}
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
    </div>
  );
}

export default CreateFolder;
