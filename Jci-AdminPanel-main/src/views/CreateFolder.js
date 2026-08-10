import React, { useState, useEffect, useMemo } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { ToastContainer, toast } from "react-toastify";
import srxc from "../assets/img/img.svg";
import ListToolbar, { matchesSearch } from "../components/ListToolbar";
import ListPagination, { paginate } from "../components/ListPagination";

function CreateFolder() {
  const [title, setTitle] = useState("");
  const [folderName, setFolderName] = useState("");
  const [image, setImage] = useState("");
  const [description, setDescription] = useState("");
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [folder, setFolder] = useState([]);
  const [render, setRender] = useState(true);
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);

  useEffect(() => {
    axios
      .get(process.env.REACT_APP_URL_ADMIN + "/jciadmin/getAllFolder")
      .then((res) => {
        setFolder(res.data.response.data.info || []);
      })
      .catch(() => setFolder([]));
  }, [render]);

  const filtered = useMemo(
    () =>
      (folder || []).filter((x) =>
        matchesSearch(x, search, ["folderName", "title", "description"])
      ),
    [folder, search]
  );

  const { page: safePage, totalPages, total, slice } = useMemo(
    () => paginate(filtered, page),
    [filtered, page]
  );

  useEffect(() => {
    if (page !== safePage) setPage(safePage);
  }, [page, safePage]);

  const onSearchChange = (value) => {
    setSearch(value);
    setPage(1);
  };

  const handleSubmit = (e) => {
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
    Object.entries(data).forEach(([key, value]) => {
      formdata.append(key, value);
    });
    axios
      .post(
        process.env.REACT_APP_URL_ADMIN + "/jciadmin/createFolder",
        formdata
      )
      .then(() => {
        setTitle("");
        setImage("");
        setDescription("");
        setFolderName("");
        toast.success("Folder Created Successfully!");
        setRender(!render);
        setLoading(false);
        e.target.reset();
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
        toast.error("Folder Creation failed!");
      });
  };

  return (
    <div className="container-fluid p-3">
      <ToastContainer />
      <div className="list-table-card mb-4" style={{ padding: "20px 22px" }}>
        <h5 className="mb-3" style={{ fontWeight: 700 }}>
          Create Folder
        </h5>
        <form onSubmit={handleSubmit} style={{ maxWidth: 520 }}>
          <div className="form-group">
            <label htmlFor="folder-name">Folder Name</label>
            <input
              type="text"
              className="form-control"
              id="folder-name"
              placeholder="Enter folder name"
              value={folderName}
              onChange={(e) => setFolderName(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label htmlFor="folder-title">Title</label>
            <input
              type="text"
              className="form-control"
              id="folder-title"
              placeholder="Enter title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label htmlFor="folder-desc">Description</label>
            <input
              type="text"
              className="form-control"
              id="folder-desc"
              placeholder="Enter description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label htmlFor="folder-image">Folder Image</label>
            <input
              type="file"
              className="form-control"
              id="folder-image"
              onChange={(e) => {
                if (e.target.files) setImage(e.target.files[0]);
              }}
            />
            <small style={{ color: "#b91c1c" }}>Max size 5mb</small>
          </div>
          {isError && (
            <small className="mt-2 d-inline-block text-danger">
              Something went wrong. Please try again later.
            </small>
          )}
          <button
            type="submit"
            className="btn btn-primary mt-2"
            disabled={loading}
          >
            {loading ? "Loading..." : "Submit"}
          </button>
        </form>
      </div>

      <ListToolbar
        title="Uploaded Folders"
        search={search}
        onSearchChange={onSearchChange}
        placeholder="Search folders by name, title, description…"
        count={total}
        countLabel="folders"
      />
      <div className="list-table-card">
        <div className="table-responsive">
          <table className="table table-sm mb-0">
            <thead>
              <tr>
                <th>S.No</th>
                <th>Folder Name</th>
                <th>Title</th>
                <th>Description</th>
                <th>Image</th>
              </tr>
            </thead>
            <tbody>
              {slice.length !== 0 ? (
                slice.map((x, index) => (
                  <tr key={x.id || index}>
                    <td>{(safePage - 1) * 10 + index + 1}</td>
                    <td style={{ textTransform: "capitalize" }}>
                      {x.folderName}
                    </td>
                    <td style={{ textTransform: "capitalize" }}>{x.title}</td>
                    <td style={{ textTransform: "capitalize" }}>
                      {x.description}
                    </td>
                    <td>
                      <img
                        src={x.image}
                        onError={(e) => (e.currentTarget.src = srxc)}
                        width="48"
                        height="48"
                        alt=""
                        style={{ borderRadius: 8, objectFit: "cover" }}
                      />
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td className="list-empty" colSpan="5">
                    {search
                      ? "No folders match your search"
                      : "No data found to display."}
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
        <ListPagination
          page={safePage}
          totalPages={totalPages}
          total={total}
          onPageChange={setPage}
        />
      </div>
    </div>
  );
}

export default CreateFolder;
